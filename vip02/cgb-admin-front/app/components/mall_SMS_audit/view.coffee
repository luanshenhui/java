Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"
#查看名单模板
nameListAuditTemplate = App.templates["name_list_audit"]
nameListContentAuditTemplate = App.templates["name_list_content_audit"]
class MallSmsTemplateAudit
  _.extend @::, TipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
    @messagePass = ".js-sms-template-pass"
    @messageRefuse = ".js-sms-template-refuse"
    @messagePreview = ".js-sms-template-preview"
    @nameListView = ".js-sms-template-name"
    @nameListAdd = ".js-sms-audit-add"
    @nameListSubmit = ".js-sms-audit-submit"
    @nameListDelete = ".js-sms-audit-delete"
    @messageSend = ".js-sms-template-send"
    @bindEvent()
  that = this
  #短信预览模板
  messagePreviewAuditTemplate = App.templates["sms_preview_audit"]

  bindEvent: ->
    $(".sms-template-audit").on "click", @messagePass, @passMessage
    $(".sms-template-audit").on "click", @messageRefuse, @refuseMessage
    $(".sms-template-audit").on "click", @messagePreview, @previewMessage
    $(".sms-template-audit").on "click", @nameListView, @viewNameList
    $(".sms-template-audit").on "click", @messageSend, @sendMessage
    $(document).on "click", @nameListAdd, @addNameList
    $(document).on "click", @nameListSubmit, @submitNameList
    $(document).on "click", @nameListDelete, @deleteNameList

    that = this

  passMessage: ->
    cks = $("td input[type='checkbox']:checked")
    if cks.length != 1
      that.alert "body", "error", "只能选择一条记录进行操作！"
      return false
    result = $("td input[type='checkbox']:checked").data("data")
    if result.status isnt "0206"
      that.alert "body", "error", "只能对“白名单发送”的数据进行操作！"
      return false
    $.ajax
      url: Store.context + "/api/mall/smsTemplate/sendMessage"
      type: "POST"
      dataType: "JSON"
      data: {
        id: result.id,
        itemCode: result.itemCode,
        itemName: result.itemName,
        perStage: result.perStage,
        stagesCode: result.stagesCode,
        goodsPrice: result.goodsPrice,
        smspId: result.smspId,
        voucherPrice: result.voucherPrice,
        couponId: result.couponId,
        couponNm: result.couponNm,
        ifPoint: result.ifPoint,
        status: result.status,
        otherMess: result.otherMess,
        loadStatus: result.loadStatus,
        sendDatetime: result.sendDatetime,
        userType: "0"
      }
      success: (data)->
        if data.data
          that.alert "body", "success", "短信发送成功！"
          window.location.href = Store.context + "/mall/sms-template/sms-audit"

  refuseMessage: ->
    cks = $("td input[type='checkbox']:checked")
    if cks.length != 1
      that.alert "body", "error", "只能选择一条记录进行操作！"
      return false
    result = $("td input[type='checkbox']:checked").data("data")
    if result.status is "0203" or result.status is "0204"
      that.alert "body", "error", " 不能对“处理中”和 “已完成”的数据进行操作！"
      return false
    id = result.id
    $.ajax
      url: Store.context + "/api/mall/smsTemplate/changeStatus/#{id}?operate=refuse"
      type: "GET"
      success: (data)=>
        window.location.href = Store.context + "/mall/sms-template/sms-audit"
      error: (e)->

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
        new Modal(messagePreviewAuditTemplate({})).show()
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
#          s = s.replace("[MESS1]", mess1)
#          s = s.replace("[MESS2]", mess2)
#        s = s.replace("[UNIT_PRICE]", unitPrice)
#        s = s.replace("[VOUCHER_NM]", voucherNm)
#        s = s.replace("[STAGE]", stage)
#        s = s.replace("[GOODS_NM]", goodsNm)
#        s = s.replace("[CARD_FOUR]", "1234")
        s = that.templateBuilder(data.data,result.couponNm,result.otherMess)
        $(".js-sms-preview").html(s)

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

  viewNameList: ->
    cks = $("td input[type='checkbox']:checked")
    if cks.length != 1
      that.alert "body", "error", "只能选择一条数据进行名单预览！"
      return false
    new Modal(nameListAuditTemplate({})).show()
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
        userType: 1
      }
      success: (data)->
        that.$jsNameList.html(nameListContentAuditTemplate(data))
        new Pagination(".nameList-pagination").total(data.data.total).show 5,
          "current_page": pageNo - 1
          callback: (pageNo) =>
            that.nameList pageNo + 1
      error: (e)->
## 白名单管理-添加
  addNameList: ->
    $(".addWhiteName").show()
    $(".js-sms-audit-submit").show()

## 白名单管理-提交
  submitNameList: ->
#    校验
    if !/^1[3|4|5|7|8][0-9]{9}$/.test $("#phoneNum").val()  #手机号码
      that.tip $("#phoneNum").parent(), "error", "up", "请输入有效手机号码！"
      $(".tip").css("left", 50).css("top", 36).css("width", 160)
      return
    if !/^[1-9]\d*$/.test $("#cardNum").val()  #卡号
      that.tip $("#cardNum").parent(), "error", "up", "请输入有效卡号！"
      $(".tip").css("left", 230).css("top", 36).css("width", 150)
      return
    #    提交
    result = $("td input[type='checkbox']:checked").data("data")
    id = result.id
    $.ajax
      url: Store.context + "/api/mall/smsTemplate/audEdit-add"
      type: "POST"
      data: {
        id: id,
        phone: $("#phoneNum").val(),
        cardNo: $("#cardNum").val()
      }
      success: (data)=>
        window.location.href = Store.context + "/mall/sms-template/sms-audit"
      error: (e)->

## 白名单管理-删除
  deleteNameList: ->
    params = []
    cks = $("td input[name='checkName']:checked")
    if cks.length == 0
      that.alert "body", "error", "请至少选择一条数据！"
      return false
    cks.each ->
      params.push(
        id: $(@).data("id")
        phone: $(@).data("phone")
      )
    $.ajax
      url: Store.context + "/api/mall/smsTemplate/audEdit-delete"
      type: "POST"
      dataType: "JSON"
      data: JSON.stringify(params)
      contentType: "application/json"
      success: (data)->
        that.alert "body", "success", "删除成功！"
        window.location.reload()

  sendMessage: ->
    cks = $("td input[type='checkbox']:checked")
    if cks.length != 1
      that.alert "body", "error", "只能选择一条数据进行白名单发送！"
      return false
    result = $("td input[type='checkbox']:checked").data("data")
    id = result.id
    $.ajax
      url: Store.context + "/api/mall/smsTemplate/look-mspCust"
      type: "GET"
      data: {
        id: id,
        userType: 1
      }
      success: (data)->
        if data.data.data is undefined
          that.alert "body", "error", "请先维护需要发送的白名单！"
          return
        else
          if result.status is "0202"
            $.ajax
              url: Store.context + "/api/mall/smsTemplate/sendMessage"
              type: "POST"
              dataType: "JSON"
              data: {
                id: result.id,
                itemCode: result.itemCode,
                itemName: result.itemName,
                perStage: result.perStage,
                stagesCode: result.stagesCode,
                goodsPrice: result.goodsPrice,
                smspId: result.smspId,
                voucherPrice: result.voucherPrice,
                couponId: result.couponId,
                couponNm: result.couponNm,
                ifPoint: result.ifPoint,
                status: result.status,
                otherMess: result.otherMess,
                loadStatus: result.loadStatus,
                sendDatetime: result.sendDatetime,
                userType: "1"
              }
              success: (data)->
                if data.data
                  window.location.href = Store.context + "/mall/sms-template/sms-audit"
#                message = data.data.retErrMsg
#                code = data.data.retCode
#                if code is "00"
#                  that.alert "body", "success", "短信发送成功！"
#                  $.ajax
#                    url:Store.context +  "/api/mall/smsTemplate/changeStatus/#{id}?operate=sendSuccess"
#                    type: "GET"
##                    data: {
##                      id:id
##                    }
#                    success: (data)=>
#                      window.location.href = Store.context + "/mall/sms-template/sms-audit"
#                    error: (e)->
#                else
#                  that.alert "body", "error", message
#                  $.ajax
#                    url:Store.context +  "/api/mall/smsTemplate/changeStatus/#{id}?operate=sendFail"
#                    type: "GET"
##                    data: {
##                      id:id
##                    }
#                    success: (data)=>
#                      window.location.href = Store.context + "/mall/sms-template/sms-audit"
#                    error: (e)->
          else
            that.alert "body", "error", "只能操作“已提交”状态的数据！"
            return false

module.exports = MallSmsTemplateAudit
