Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"
#查看名单模板
nameListTemplate = App.templates["name_list"]
nameListContentTemplate = App.templates["name_list_content"]
#导入结果查询
importResultTemplate = App.templates["import_result"]
importResultContentTemplate = App.templates["import_result_content"]

#设置模板
messageTemplate = App.templates["sms_template_new"]
#短信预览模板
messagePreviewTemplate = App.templates["sms_preview"]
#名单导入模板
nameListImportTemplate = App.templates["name_list_import"]

class MallSmsTemplate
  _.extend @::, TipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  startPicker = null
  endPicker = null

  constructor: ($)->
    @messageNew = ".js-sms-template-add"
    @messageUpdate = ".js-sms-template-update"
    @messageSubmit = ".js-sms-template-submit"
    @importNameListBtn = ".js-sms-template-import"
    #@uploadImportFileBtn = ".upload-file"
    @messagePreview = ".js-sms-template-preview"
    @nameListView = ".js-sms-template-name"
    @importResultView = ".js-sms-template-result"
    @checkAll = ".js-all-check" #全选按钮
    @checkThis = ".js-check-this" #列表页每一行前面的checkbox
    @allSubmit = ".js-all-submit" #全选提交
    @allDelete = ".js-all-delete" #全选删除
    @sendNow = ".send-now" #选择立即发送
    @uploadFileBtn = ".js-file-upload"
    @$jsNameList = null
    @bindEvent()
  that = this

  bindEvent: ->
    that = this
    #    新增
    $(".sms-template").on "click", @messageNew, @newMessage
    #    编辑
    $(".sms-template").on "click", @messageUpdate, @updateMessage
    #    提交
    $(document).on "confirm:submit-template", @submitAll
    #    删除
    $(document).on "confirm:delete-template", @deleteAll
    #    短信预览
    $(".sms-template").on "click", @messagePreview, @previewMessage
    #    名单预览
    $(".sms-template").on "click", @nameListView, @viewNameList
    #    导入结果查询
    $(".sms-template").on "click", @importResultView, @viewImportResult
    #    全选按钮事件
    $(".sms-template").on "click", @checkAll, @checkAllTemplates
    #    反向全选事件
    $(".sms-template").on "click", @checkThis, @checkThisTemplates
    #    全选后操作事件 提交
    $(".sms-template").on "click", @allSubmit, @submitAll
    #    全选后操作事件 删除
    $(".sms-template").on "click", @allDelete, @deleteAll
    #    导入名单
    $(".sms-template").on "click", @importNameListBtn, @importNameList
    #    名单导入提交
    #$(document).on "change",@uploadImportFileBtn, @uploadImportFile
    #    立即发送
    $(document).on "click", @sendNow, @nowSend
    #    下载导入结果
    $(document).on "click", @uploadFileBtn, @uploadFile

#    选择立即发送的触发事件
  nowSend: ->
    if $(".send-now").is(":checked")
      $("#sendDatetime").val("")
      $("#sendDatetime").attr("disabled", "disabled")
    else
      $("#sendDatetime").removeAttr("disabled")

  newMessage: ->
    new Modal(messageTemplate({})).show()
    $(".sms-template-new").on "change", ".js-select-template", that.bindTempEvent ## 选择框
    $(".sms-template-new").on "blur", "#itemCode", that.bindTempEvent ## 单品编码
    $(".sms-template-new").on "blur", "#couponId", that.bindTempEvent ## 优惠选择
    $(".sms-template-new").on "change", "#otherMess", that.bindTempEvent ## 手工选择
    #    $(".sms-template-form").find(".datepicker").datepicker()
    startPicker = new Pikaday(
      field: $(".js-date-start")[0]
      i18n: {
        previousMonth: "上月",
        nextMonth: "下月",
        months: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
        weekdays: ["周日", "周一", "周二", "周三", "周四", "周五", "周六"],
        weekdaysShort: ["日", "一", "二", "三", "四", "五", "六"]
      }
      onSelect: ->
        startDate = ($(".js-date-start").val()).replace(/-/g, "/")
        endPicker.setMinDate(new Date(startDate))
    )
    endPicker = new Pikaday(
      field: $(".js-date-end")[0]
      i18n: {
        previousMonth: "上月",
        nextMonth: "下月",
        months: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
        weekdays: ["周日", "周一", "周二", "周三", "周四", "周五", "周六"],
        weekdaysShort: ["日", "一", "二", "三", "四", "五", "六"]
      }
      onSelect: ->
        endDate = ($(".js-date-end").val()).replace(/-/g, "/")
        startPicker.setMaxDate(new Date(endDate))
    )

    #    页面加载时加载短信模板开始
    $.ajax
      url: Store.context + "/api/mall/smsTemplate/ae-smsTemplate"
      type: "GET"
      success: (data)->
        s = "<option value=''>请选择</option>"
        s = s + "<option value=" + item.smspId + ">" + item.smspId + "</option>" for item in data.data
        $("#smspId").html(s)
    #    页面加载时加载短信模板结束
    #    页面加载时加载优惠券项目名称开始
    $.ajax
      url: Store.context + "/api/admin/coupon/couponInf"
      type: "GET"
      success: (data)->
        s = "<option value=''>请选择</option>"
        s = s + "<option value=" + item.couponId + ">" + item.couponNm + "</option>" for item in data.data
        $("#couponId").html(s)
    #    页面加载时加载优惠券项目名称结束
    $("form.sms-template-form").validator
      isErrorOnParent: true
    $("form.sms-template-form").on "submit", that.messageTemplateAdd

  updateMessage: ->
    cks = $("td input[type='checkbox']:checked")
    if cks.length != 1
      that.alert "body", "error", "只能选择一条数据进行编辑！"
      return false
    result = $("td input[type='checkbox']:checked").data("data")
    #    只有状态为待处理和已拒绝的允许编辑
    if result.status is "0201" or result.status is "0205"
      result.beginDate = parseInt(result.beginDate);
      result.endDate = parseInt(result.endDate);
      #    编辑页面加载时加载短信模板开始
      $.ajax
        url: Store.context + "/api/mall/smsTemplate/ae-smsTemplate"
        type: "GET"
        success: (data)->
          s = "<option value=''>请选择</option>"
          for item in data.data
            if item.smspId + "" is result.smspId
              s = s + "<option value=" + item.smspId + " selected>" + item.smspId + "</option>"
            else
              s = s + "<option value=" + item.smspId + ">" + item.smspId + "</option>"
            $("#smspId").html(s)
      #     编辑页面加载时加载短信模板结束
      #    编辑页面加载时加载优惠券项目名称开始
      $.ajax
        url: Store.context + "/api/admin/coupon/couponInf"
        type: "GET"
        success: (data)->
          s = "<option value=''>请选择</option>"
          for item in data.data
            if item.couponId + "" is result.couponId
              s = s + "<option value=" + item.couponId + " selected>" + item.couponNm + "</option>"
            else
              s = s + "<option value=" + item.couponId + ">" + item.couponNm + "</option>"
          $("#couponId").html(s)

      #    编辑页面加载时加载短信样例开始
      smspId = result.smspId;
      itemCode = result.itemCode;
      $.ajax
        url: Store.context + "/api/mall/smsTemplate/ae-findSmspMess"
        type: "POST"
        data: {
          smspId: smspId,
          itemCode: itemCode
        }
        success: (data)->
          s = that.templateBuilder(data.data,result.couponNm,result.otherMess)
          $("#smsTemplate").html(s)
      
      #    编辑页面加载时加载短信样例结束
      new Modal(messageTemplate({data: result})).show()
      $(".sms-template-new").on "change", ".js-select-template", that.bindTempEvent ## 选择框
      $(".sms-template-new").on "blur", "#itemCode", that.bindTempEvent ## 单品编码
      $(".sms-template-new").on "blur", "#couponId", that.bindTempEvent ## 优惠选择
      $(".sms-template-new").on "change", "#otherMess", that.bindTempEvent ## 手工选择

      startDate = ($(".js-date-start").val()).replace(/-/g, "/")
      endDate = ($(".js-date-end").val()).replace(/-/g, "/")
      startPicker = new Pikaday(
        field: $(".js-date-start")[0]
        i18n: {
          previousMonth: "上月",
          nextMonth: "下月",
          months: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
          weekdays: ["周日", "周一", "周二", "周三", "周四", "周五", "周六"],
          weekdaysShort: ["日", "一", "二", "三", "四", "五", "六"]
        }
        onSelect: ->
          endPicker.setMinDate(new Date(startDate))
      )
      endPicker = new Pikaday(
        field: $(".js-date-end")[0]
        i18n: {
          previousMonth: "上月",
          nextMonth: "下月",
          months: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
          weekdays: ["周日", "周一", "周二", "周三", "周四", "周五", "周六"],
          weekdaysShort: ["日", "一", "二", "三", "四", "五", "六"]
        }
        onSelect: ->
          startPicker.setMaxDate(new Date(endDate))
      )
      endPicker.setMinDate(new Date(startDate))
      startPicker.setMaxDate(new Date(endDate))

      $("form.sms-template-form").validator
        isErrorOnParent: true
      $("form.sms-template-form").on "submit", that.messageTemplateUpdate
    else
      that.alert "body", "error", "只能编辑“待处理”或“已拒绝”状态的数据！"
      return false

  messageTemplateAdd: (evt)->
    evt.preventDefault()
    $("form.sms-template-form").validator
      isErrorOnParent: true
    data = $("form.sms-template-form").serializeObject();
    # 校验开始
    if data.smspId == ''
      that.tip $("#smspId").parent(), "error", "up", "请选择短信模板！"
      $(".tip").css("left", 150).css("top", 36).css("width", 150)
      return
    if data.beginDate == ''
      that.tip $("#beginDate").parent(), "error", "up", "请选择有效期开始时间！"
      $(".tip").css("left", 120).css("top", 36).css("width", 200)
      return
    if data.endDate == ''
      that.tip $("#endDate").parent(), "error", "up", "请选择有效期结束时间！"
      $(".tip").css("left", 320).css("top", 36).css("width", 200)
      return
    if data.voucherPrice isnt ""
      if !/^[0-9]\d*$/.test data.voucherPrice
        that.tip $("#voucherPrice").parent(), "error", "up", "请输入非负整数优惠金额！"
        $(".tip").css("left", 150).css("top", 36).css("width", 200)
        return

    if $(".send-now").is(":checked")
      data.sendDatetime = 0
    else
      if data.sendDatetime == ''
        that.tip $("#sendDatetime").parent(), "error", "up", "请选择短信发送时间！"
        $(".tip").css("left", 120).css("top", 36).css("width", 200)
        return

#    otherMess = data.otherMess
    #    smsTemplate = data.smsTemplate
#    smsTemplate = goodsInfo.smspMess

#    otherMessLength = otherMess.split("|").length #手工参数的数量
#    needOtherMessLength = smsTemplate.split("MESS").length - 1 #计算短信模板中需要手工参数的数量
#    if needOtherMessLength != otherMessLength
#      that.tip $("#otherMess").parent(), "error", "up", "手工参数输入数量有误！"
#      $(".tip").css("left", 150).css("top", 36).css("width", 200)
#      return

    # 校验当前短信模板 内容信息是否完整
    templateContent = $("textarea[name=smsTemplate]").val()
    if !templateContent or (templateContent.indexOf("[MESS1]") isnt -1) or (templateContent.indexOf("[MESS2]") isnt -1)
      that.tip $(".detail-address").parent(), "error", "up", "手工参数格式不正确！"
      $(".tip").css("left", 150).css("top", 36).css("width", 200)
      return

    #当短信模板中含有[VOUCHER_NM]字段时，校验优惠券项目名称必填
    if !templateContent or (templateContent.indexOf("[VOUCHER_NM]") isnt -1)
      that.tip $("#couponId").parent(), "error", "up", "请选择优惠券项目名称！"
      $(".tip").css("left", 150).css("top", 36).css("width", 200)
      return

    #当短信模板中含有[VOUCHER_NM]字段时，校验优惠券项目名称必填
#    if smsTemplate.indexOf("[VOUCHER_NM]") isnt -1
#      if data.couponId == ''
#        that.tip $("#couponId").parent(), "error", "up", "请选择优惠券项目名称！"
#        $(".tip").css("left", 150).css("top", 36).css("width", 200)
#        checkContentFlag = false
#        return
#    if !checkContentFlag
    #    校验结束
    #将string型转为date型
    startTime = data.beginDate
    endTime = data.endDate
    data.beginDate = new Date(startTime.replace(/-/g, "/"))
    data.endDate = new Date(endTime.replace(/-/g, "/"))
    #插入当前状态
    data.status = '0201'
    couponId = $("#couponId").val()
    if couponId
      data.couponNm = $("select[name=couponId] option:selected").text()

    goodsInfo = $("#smsTemplate").data("data")
    # 商品信息
    stage = goodsInfo.installmentNumber #最高分期数
    totalPrice = goodsInfo.price #单品价格
    if stage and totalPrice
      everyPrice = totalPrice / stage
      data.perStage = everyPrice.toFixed(2) #每期价格
      data.goodsPrice = totalPrice
      data.stagesCode = stage
    data.itemName = goodsInfo.goodsName

    $.ajax
      url: Store.context + "/api/mall/smsTemplate/add"
      type: "POST"
      data: data
      success: (data)->
        window.location.reload()
      error: (data) ->
        new Modal(
          icon: "error"
          title: "出错啦！"
          content: data.responseText || "未知故障"
          overlay: false)
        .show()
  ## 修改
  messageTemplateUpdate: (evt)->
    evt.preventDefault()
    $("form.sms-template-form").validator
      isErrorOnParent: true
    data = $("form.sms-template-form").serializeObject();
    #    校验开始
    if data.smspId == ''
      that.tip $("#smspId").parent(), "error", "up", "请选择短信模板！"
      $(".tip").css("left", 150).css("top", 36).css("width", 150)
      return
    if data.beginDate == ''
      that.tip $("#beginDate").parent(), "error", "up", "请选择有效期开始时间！"
      $(".tip").css("left", 120).css("top", 36).css("width", 200)
      return
    if data.endDate == ''
      that.tip $("#endDate").parent(), "error", "up", "请选择有效期结束时间！"
      $(".tip").css("left", 320).css("top", 36).css("width", 200)
      return
    if data.voucherPrice isnt ""
      if !/^[0-9]\d*$/.test data.voucherPrice
        that.tip $("#voucherPrice").parent(), "error", "up", "请输入非负整数优惠金额！"
        $(".tip").css("left", 150).css("top", 36).css("width", 200)
        return
    if $(".send-now").is(":checked")
      data.sendDatetime = 0
    else
      if data.sendDatetime == ''
        that.tip $("#sendDatetime").parent(), "error", "up", "请选择短信发送时间！"
        $(".tip").css("left", 120).css("top", 36).css("width", 200)
        return

#    otherMess = data.otherMess
    # 校验当前短信模板 内容信息是否完整
    templateContent = $("textarea[name=smsTemplate]").val()
    if !templateContent or (templateContent.indexOf("[MESS1]") isnt -1) or (templateContent.indexOf("[MESS2]") isnt -1)
      that.tip $(".detail-address").parent(), "error", "up", "手工参数格式不正确！"
      $(".tip").css("left", 150).css("top", 36).css("width", 200)
      return

    #当短信模板中含有[VOUCHER_NM]字段时，校验优惠券项目名称必填
    if !templateContent or (templateContent.indexOf("[VOUCHER_NM]") isnt -1)
      that.tip $("#couponId").parent(), "error", "up", "请选择优惠券项目名称！"
      $(".tip").css("left", 150).css("top", 36).css("width", 200)
      return

#    smsTemplate = goodsInfo.smspMess
#    otherMessLength = otherMess.split("|").length #手工参数的数量
#    needOtherMessLength = smsTemplate.split("MESS").length - 1 #计算短信模板中需要手工参数的数量
#    if needOtherMessLength != otherMessLength
#      that.tip $("#otherMess").parent(), "error", "up", "手工参数输入数量有误！"
#      $(".tip").css("left", 150).css("top", 36).css("width", 200)
#      return
    #当短信模板中含有[VOUCHER_NM]字段时，校验优惠券项目名称必填
#    couponNmFlag = true
#    if smsTemplate.indexOf("[VOUCHER_NM]") isnt -1
#      if data.couponId == ''
#        that.tip $("#couponId").parent(), "error", "up", "请选择优惠券项目名称！"
#        $(".tip").css("left", 150).css("top", 36).css("width", 200)
#        couponNmFlag = false
#        return
#    if couponNmFlag is false
#      return
    #    校验结束
    #将string型转为date型
    startTime = data.beginDate
    endTime = data.endDate
    data.beginDate = new Date(startTime.replace(/-/g, "/"))
    data.endDate = new Date(endTime.replace(/-/g, "/"))
    #插入当前状态
    data.status = '0201'
    data.couponNm = $("select[name=couponId] option:selected").text()

    goodsInfo = $("#smsTemplate").data("data")
    # 商品信息
    stage = goodsInfo.installmentNumber #最高分期数
    totalPrice = goodsInfo.price #单品价格
    if stage and totalPrice
      everyPrice = totalPrice / stage
      data.perStage = everyPrice.toFixed(2) #每期价格
      data.goodsPrice = totalPrice
      data.stagesCode = stage
    data.itemName = goodsInfo.goodsName
    $.ajax
      url: Store.context + "/api/mall/smsTemplate/edit"
      type: "POST"
      data: data
      success: (data)->
        window.location.reload()
      error: (data) ->
        new Modal(
          icon: "error"
          title: "出错啦！"
          content: data.responseText || "未知故障"
          overlay: false)
        .show()

#    选择短信模板的触发事件 根据创建修改的内容进行模板内容的变化
  bindTempEvent: ()->
    smspId = $("#smspId").val()
    itemCode = $("#itemCode").val()
    #    当点击的是请选择时候不做操作
    if !smspId
      $("#smsTemplate").html("")
      return
    $.ajax
      url: Store.context + "/api/mall/smsTemplate/ae-findSmspMess"
      type: "POST"
      data: {
        smspId: smspId,
        itemCode: itemCode
      }
      success: (data)->
        s = that.templateBuilder(data.data, null, null)
        $("#smsTemplate").html(s)

  ## 短信模板生成
  templateBuilder: (data, voucherNm, otherMess)->
#   取短信模板
    s = data.smspMess
    #  取出短信模板所需要的值
    goodsNm = data.goodsName #单品名称
    stage = data.installmentNumber #最高分期数
    totalPrice = data.price #单品价格
    if !voucherNm
      couponId = $("select[name=couponId]").val() ## 判断是否选择
      if couponId
        voucherNm = $("select[name=couponId] option:selected").text() #优惠券项目名称
    if !otherMess
      otherMess = $("textarea[name=otherMess]").val() #手工参数

    if voucherNm
      s = s.replace("[VOUCHER_NM]", voucherNm)
    if otherMess
      mess = otherMess.split("|") #将手工参数分割成数组
      mess1 = mess[0] #手工参数的值与模板值对应
      if mess.length == 2
        mess2 = mess[1]
      if s.indexOf("[MESS1]") isnt -1 and mess1
        s = s.replace("[MESS1]", mess1)
      if s.indexOf("[MESS2]") isnt -1 and mess2
        s = s.replace("[MESS2]", mess2)

    if stage and totalPrice
      everyPrice = totalPrice / stage
      unitPrice = everyPrice.toFixed(2) #每期价格
      s = s.replace("[UNIT_PRICE]", unitPrice)
      s = s.replace("[STAGE]", stage)
    if goodsNm
      s = s.replace("[GOODS_NM]", goodsNm)
    s = s.replace("[CUST_NM]", "张三")
    s = s.replace("[CARD_FOUR]", "1234")
    $("#smsTemplate").data("smspMess", data.smspMess)
    $("#smsTemplate").data("data", data)
    s

  previewMessage: ->
    cks = $("td input[type='checkbox']:checked")
    if cks.length != 1
      that.alert "body", "error", "只能选择一条数据进行预览！"
      return false
    result = $("td input[type='checkbox']:checked").data("data")
    smspId = result.smspId
    itemCode = result.itemCode
    $.ajax
      url: Store.context + "/api/mall/smsTemplate/ae-findSmspMess"
      type: "POST"
      data: {
        smspId: smspId,
        itemCode: itemCode
      }
      success: (data)->
        new Modal(messagePreviewTemplate({})).show()
#        #        取手工参数
#        result = $("td input[type='checkbox']:checked").data("data")
#        #        取短信模板
#        s = data.data.smspMess
#        #        取出短信模板所需要的值
#        goodsNm = data.data.goodsName #单品名称
#        stage = data.data.installmentNumber #最高分期数
#        totalPrice = data.data.price #单品价格
#        everyPrice = totalPrice / stage
#        unitPrice = everyPrice.toFixed(2) #每期价格
#        voucherNm = result.couponNm #优惠券项目名称
#        otherMess = result.otherMess #手工参数
#        mess = otherMess.split("|") #将手工参数分割成数组
#        mess1 = mess[0] #手工参数的值与模板值对应
#        mess2 = mess[1]
#        s = s.replace("[CUST_NM]", "张三")
#        if s.indexOf("[MESS1]") is -1
#          s = s.replace("[MESS2]", mess1)
#        else
#          s = s.replace("[MESS2]", mess2)
#          s = s.replace("[MESS1]", mess1)
#        s = s.replace("[UNIT_PRICE]", unitPrice)
#        s = s.replace("[VOUCHER_NM]", voucherNm)
#        s = s.replace("[STAGE]", stage)
#        s = s.replace("[GOODS_NM]", goodsNm)
#        s = s.replace("[CARD_FOUR]", "1234")
        s = that.templateBuilder(data.data,result.couponNm,result.otherMess)
        $(".js-sms-preview").html(s)

  viewNameList: ->
    cks = $("td input[type='checkbox']:checked")
    if cks.length != 1
      that.alert "body", "error", "只能选择一条数据进行名单预览！"
      return false
    new Modal(nameListTemplate({})).show()
    that.$jsNameList = $(".js-name-list")
    that.nameList(1)
  nameList: (pageNo) ->
    result = $("td input[type='checkbox']:checked").data("data")
    id = result.id
    $.ajax
      url: Store.context + "/api/mall/smsTemplate/look-mspCust?size=5&pageNo=#{pageNo}"
      type: "GET"
      data: {
        id: id,
        userType: 0
      }
      success: (data)->
        that.$jsNameList.html(nameListContentTemplate(data))
        new Pagination(".nameList-pagination").total(data.data.total).show 5,
          "current_page": pageNo - 1
          callback: (pageNo) =>
            that.nameList pageNo + 1
  checkAllTemplates: (evt)->
    if $(@).is(':checked')
      $("input[name='checkSmsTemplate']").prop("checked", 'checked')
    else
      $("input[name='checkSmsTemplate']").prop("checked", '')

  checkThisTemplates: (evt)->
    if $("input[name='checkSmsTemplate']:checked")
      item = $("input[name='checkSmsTemplate']:checked").length;
      all = $("input[name='checkSmsTemplate']").length;
      if(item == all)
        $("input[name='checkAll']").prop("checked", 'checked')
      else
        $("input[name='checkAll']").prop("checked", '')
#   全选后的各项操作
  submitAll: (evt)->
    evt.preventDefault()
    params = []
    checkFlag = true #提交标识
    cks = $("input[name='checkSmsTemplate']:checked")
    if cks.length == 0
      that.alert "body", "error", "请至少选择一条数据！"
      return false
    cks.each ->
      if $(this).data("status") + "" == "0201"
      else
        that.alert "body", "error", "只能操作“待处理”状态的数据！"
        checkFlag = false
        return
      if $(this).data("loadstatus") + "" == "0202"
        params.push(
          id: $(@).data("id")
        )
      else
        that.alert "body", "error", "请先导入名单"
        checkFlag = false
        return

    if checkFlag
      $.ajax
        url: Store.context + "/api/mall/smsTemplate/ae-submitAll"
        type: "POST"
        dataType: "JSON"
        data: JSON.stringify(params)
        contentType: "application/json"
        success: (data)->
          if data.data.result
            that.alert "body", "error", "以下短信没有名单提交失败：" + data.data.result
          else
            that.alert "body", "success", "提交成功！"
          window.setTimeout((->
            window.location.reload()),1500)
  # 删除
  deleteAll: (evt)->
    evt.preventDefault()
    params = []
    deleteFlag = true
    cks = $("td input[type='checkbox']:checked")
    if cks.length == 0
      that.alert "body", "error", "请至少选择一条数据！"
      return false
    cks.each ->
#      逻辑思路：只能删除“待处理”、“已完成”、“已拒绝”状态的数据
#               “已完成”状态下短信模板有效时间内不允许删除！
#                 0201--待处理 0204--已完成 0205--已拒绝
      data = $(this).data("data")
      status = data.status
      if status is "0201" or status is "0204" or status is "0205"
        ## 已完成状态得短信模板当天得不允许删除
        if status is "0204"
          endDate = parseInt data.endDate
          newDate = parseInt data.newDate
          if endDate > newDate
            that.alert "body", "error", "“已完成”状态下短信模板有效时间内不允许删除！"
            deleteFlag = false
            return
        params.push(
          id: $(@).data("id")
        )
      else
        that.alert "body", "error", "只能操作“待处理”、“已完成”、“已拒绝”状态的数据！"
        deleteFlag = false
        return
    if deleteFlag
      $.ajax
        url: Store.context + "/api/mall/smsTemplate/deleteAll"
        type: "POST"
        dataType: "JSON"
        data: JSON.stringify(params)
        contentType: "application/json"
        success: (data)->
          that.alert "body", "success", "删除成功！"
          window.location.reload()

  importNameList: (evt)->
    cks = $("td input[type='checkbox']:checked")
    if cks.length != 1
      that.alert "body", "error", "只能选择一条数据进行批量导入！"
      return false
    result = $("td input[type='checkbox']:checked").data("data")
    if result.status != "0201" and result.status != "0205"
      that.alert "body", "error", "只能操作“待处理”和“已拒绝”状态的数据！"
      return false
    if result.loadStatus is "0201"
      that.alert "body", "error", "上一批导入未完成，请稍后处理！"
      return false
    importModal = new Modal nameListImportTemplate({})
    importModal.show()
    $("form.name-add-form").validator
      isErrorOnParent: true

  uploadImportFile: (evt)->
    file = $(that.uploadImportFileBtn).val()
    if file isnt ""
      resValArray = file.split('\\')
      $(".file-input").val(resValArray[resValArray.length - 1])
    else
      $(".file-input").val(file)

  uploadFile: (evt)->
    $("form.name-add-form").validator
      isErrorOnParent: true
    result = $("td input[type='checkbox']:checked").data("data")
    id = result.id
    $(that.uploadFileBtn).fileupload
      url: Store.context + '/api/mall/smsTemplate/ae-nameListUpload?id=' + id #用于文件上传的服务器端请求地址
      dataType: "json"
      done: (evt, data) =>
        if data.result.resultFlag
          that.alert "body", "success", "文件正在上传，请稍等..."
          window.location.reload()
      fail: (evt, data) ->
        jqXHR = data.jqXHR
        if jqXHR.status is 413
          "上传的文件超过规定大小"
        else
          jqXHR.responseText
      error:(data)->
        responseText = ""
        if data.status is 413 then responseText = "上传的文件超过规定大小" else responseText = data.responseText
        new Modal(
          icon: "error"
          title: "出错啦！"
          content: responseText
          overlay: false)
        .show()

#  导入结果查询
  viewImportResult: ->
    cks = $("td input[type='checkbox']:checked")
    if cks.length != 1
      that.alert "body", "error", "只能选择一条数据进行导入结果查询！"
      return false
    new Modal(importResultTemplate({})).show()
    that.$jsImportResult = $(".js-import-result-list")
    that.importResult(1)
  importResult: (pageNo) ->
    result = $("td input[type='checkbox']:checked").data("data")
    id = result.id
    ###获取路径###
    url = $("table.table").data("url")
    $.ajax
      url: Store.context + "/api/mall/smsTemplate/look-importResult?size=5&pageNo=#{pageNo}"
      type: "get"
      data: {
        id: id
      }
      success: (data)->
        data.url = url
        that.$jsImportResult.html(importResultContentTemplate(data))
        new Pagination(".import-result-pagination").total(data.data.total).show 5,
          "current_page": pageNo - 1
          callback: (pageNo) =>
            that.importResult pageNo + 1

module.exports = MallSmsTemplate
