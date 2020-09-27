Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"
class PresentManage
  _.extend @::, TipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show();

  that = this
  itemStock = App.templates['item_stock_present']
  itemRefuse = App.templates['item_refuse_present']
  itemPendPriced = App.templates['item_pend_priced']
  itemPriceReviewed = App.templates['item_price_reviewed']
  itemSelectTemplate = App.templates["item_select"]
  itemImport = App.templates['present_import']
  itemImportResult = App.templates['items_import_result']

  startPicker = null
  endPicker = null

  constructor: ->
    that = this
    @putShelfBtn = ".js-put-shelf" #上下架按钮
    @shelfStatusAll = ".js-shelfStatus-all" #一键上架
    @downShelfAll = ".js-shelf-down-all" #一键下架
    @select1 = ".js-select1" #后台类目一级
    @select2 = ".js-select2" #后台类目二级
    @editStock = ".js-edit-stock" #修改库存按钮
    @editPrice = ".js-item-price" #修改价格按钮
    @checkAll = ".js-all-check" #全选按钮
    @checkThisItem = ".js-check-this" #列表页每一行前面的checkbox
    @allPass = ".js-all-pass" #全选通过
    @allRefuse = ".js-all-refuse" #全选拒绝
    @submitGoodsBtn = ".js-submit-goods" #提交按钮
    @pendingPriced = ".js-pending-priced"  #定价按钮
    @pricedReviewed = ".js-priced-reviewed"
    @changePricedReviewed = ".js-change-priced-reviewed"
    @remainingTarget = ".remaining-target"
    @$itemSearchBtn = $(".js-item-search")
    @putShelfAllBtn=".js-all-shelf" #全选后上下架按钮
    @$exportItemBtn = $(".js-export") #礼品导出按钮
    @jsImportBtn = $(".js-import") #导入按钮
    @jsImportBtn.on "click",@showImportModal
    @importItemBtn = ".js-import-btn" #上传按钮
    @fileSelectBtn = ".js-file-select" #文件选择按钮

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
    @bindEvent()
    @backCategoryInit()
    @regionTypeInit()
#绑定事件


  bindEvent: ->
    that = this
    $(".points-present").on "click", @putShelfBtn, @putShelfStatus #点击上下架
    $(".points-present").on "click", @shelfStatusAll, @putShelfStatusAll #点击一键上架，上架所有渠道
    $(".points-present").on "click", @downShelfAll, @putShelfStatusAll #点击一键下架，下架所有渠道
    $(".points-present").on "click", @editStock, @editGoodsStock #点击库存按钮，弹出编辑库存的弹框
    $(".points-present").on "click", @editPrice, @editGoodsPrice #点击改价按钮，弹出编辑价格的弹框
    $(".points-present").on "click", @checkAll, @checkAllGoods #全选按钮事件
    $(".points-present").on "click", @allPass, @passAll #全选后操作事件
    $(".points-present").on "click", @allRefuse, @refuseAll #全选后操作事件
    $(".points-present").on "click", @checkThisItem, @checkItem #反向全选事件
    $(".points-present").on "click", @submitGoodsBtn, @submitGoodsToAudit
    $(".points-present").on "change", @select1, ->
      that.selectCategory($(@), null, null, null)
    $(".points-present").on "change", @select2, ->
      that.selectCategory($(@), null, null, null)
    $(".points-present").on "click", @pendingPriced, @pricedPending  #点击定价显示定价信息弹框
    $(".points-present").on "click", @pricedReviewed, @reviewedPriced #定价审核Modal
    $(document).on "keyup", @remainingTarget, @remainingText
    $(document).on "blur", @remainingTarget, @remainingText
    @$exportItemBtn.on "click", @exportItemData
    @$itemSearchBtn.on "click", @exportItemData
    $(".points-present").on "click",@putShelfAllBtn,@putShelfAll
    $(document).on "click",@importItemBtn,@importFormSubmit
    $(document).on "change",@fileSelectBtn,@fileSelect

  showImportModal:->
    importModal = new Modal itemImport()
    importModal.show()

  fileSelect:()->
    fileName = $(".upload-file").val()
    $(".js-file-name").val(fileName)

  importFormSubmit:(evt)->
    fileName = $(".upload-file").val()
    if fileName is ""
      that.alert "body", "error", "请选择文件后再点击上传 ！"
      return
    $(".js-file-name").val(fileName)
    fileText = fileName.substring(fileName.lastIndexOf("."),fileName.length).toLowerCase()
    if fileText isnt ".xlsx" and fileText isnt ".xls"
      that.alert "body", "error", "请选择正确的文件格式上传 ！"
      return
    $(".js-import-form").attr("method", "post")
    $(".js-import-form").attr("action", "/mmc/api/admin/goods/importGiftsData")
    $(".js-import-form").attr("enctype", "multipart/form-data")
    $("form.js-import-form").submit()




  exportItemData: (evt)->
    if $(@).data("type") is "export"
      $(".js-form-search").attr("method", "POST")
      $(".js-form-search").attr("action", Store.context + "/api/admin/goods/exportGoodsData")
      $("form.js-form-search").submit()
    else
      query = $("form.js-form-search").serializeObject()
      backCategory3Id = query.backCategory3Id
      backCategory1Id = query.backCategory1Id
      if backCategory1Id isnt "" and backCategory3Id is ""
        that.alert "body", "error", "请选择到三级类目进行查询！"
        return
      searchAction = window.location.href
      searchAction = searchAction.split("?")[0]
      $(".js-form-search").attr("method", "GET")
      $(".js-form-search").attr("action", searchAction)
      $("form.js-form-search").submit()

  regionTypeInit: ->
    regionType = $.query.get('regionType')
    $.ajax
      url: Store.context + "/api/admin/pointsPresent/findRegionType"
      type: "GET"
      success: (result)->
        html = ''
        $.each(result.data, (index, item)->
          html += '<option  value=' + item.areaId + '>' + item.areaName + '</option>'
        )
        $('#regionType').html('<option  value="">请选择</option>').append(html)
        $('#regionType').val(regionType)

  #后台类目初始化
  backCategoryInit: ->
    #获取浏览器地址栏中相应字段的值
    backCategory1 = $.query.get('backCategory1Id')
    backCategory2 = $.query.get('backCategory2Id')
    backCategory3 = $.query.get('backCategory3Id')
    if backCategory1 isnt true and backCategory1 isnt ""
      that.selectCategory(null, 1, 0, backCategory1)
      if backCategory2 isnt true and backCategory2 isnt ""
        that.selectCategory(null, 2, backCategory1, backCategory2)
        if backCategory3 isnt true and backCategory3 isnt ""
          that.selectCategory(null, 3, backCategory2, backCategory3)
    else
      that.selectCategory(null, 1, 0, null)

  ###搜索条件中后台类目联动###
  # $this 当前对象
  # next 将要变动的select
  # categoryId 给变动的select赋初值
  ###########################
  selectCategory: ($this, next, parentId, categoryId)->
    if !next or next is ""
      level = $this.data("level")
      next = level + 1
      parentId = $this.val()

    $.ajax
      url: Store.context + "/api/admin/backCategories/#{parentId}/children?channel=JF"
      type: "GET"
      success: (result)->
        if result.data
          if $this and level is 1
            $(".js-select#{next + 1}").html("<option value=\"\">请选择</option>")
          $(".js-select#{next}").empty()
          $(".js-select#{next}").append(itemSelectTemplate(data: result.data))
          if categoryId and categoryId isnt ""
            $(".js-select#{next}").val(categoryId)
        else
          $(".js-select#{next}").html("<option value=\"\">请选择</option>")
          $(".js-select#{next + 1}").html("<option value=\"\">请选择</option>")


  putShelfStatus: (evt)->
    $btn = $(@)
    channel = $(@).parent().data("channel") #获取渠道
    #获取 父级DIV
    $parentDiv = $(@).parents(".order-tab")
    code = $parentDiv.data("code")
    array=[]
    array.push code
    autoOffShelfTime = $parentDiv.data("autooffshelftime")
    #获取当前状态值
#    state = $(@).parent().data("state")
    #判断当前礼品状态，只有在审核通过的状态下才可以进行操作
    approveStatus = String($(@).parents(".table-state").data("status"))
    if approveStatus is "06" or approveStatus is "72" or approveStatus is "73" or approveStatus is "74"
      if !$btn.hasClass("icon-img-on")
        if that.checkTime(autoOffShelfTime)
          changeState = '02'
        else
          that.alert "body", "error", "当前礼品已经自动下架，无法上架礼品，请修改自动下架时间！"
          return;
      else
        changeState = '01'
      $.ajax
        url: Store.context + "/api/admin/goods/updateGdShelf"
        type: "POST"
        data: array: array,channels:channel,status:changeState
        success: (data)->
          that.alert "body", "success", "保存成功！"
          if $btn.hasClass("icon-img-down")
            $btn.removeClass("icon-img-down").addClass("icon-img-on")
          else
            $btn.removeClass("icon-img-on").addClass("icon-img-down")
    else
      that.alert "body", "error", "请等待审核完成后再进行上下架操作！"


  getChannelHasOnShelves:(_this)->
    onChannels = []
    downChannels = []
    pointsState = _this.closest("tr").find(".js-chennel-points").find("i").hasClass("icon-img-on")  #积分商城渠道状态
    ccStatus =  _this.closest("tr").find(".js-channel-cc").find("i").hasClass("icon-img-on") #CC渠道状态
    phoneStatus = _this.closest("tr").find(".js-channel-phone").find("i").hasClass("icon-img-on")  #手机银行渠道状态
    smsStatus = _this.closest("tr").find(".js-channel-sms").find("i").hasClass("icon-img-on") #短信渠道状态
    ivrStatus = _this.closest("tr").find(".js-channel-ivr").find("i").hasClass("icon-img-on") #短信渠道状态
    if pointsState is false then  onChannels.push "channelPoints" else downChannels.push "channelPoints"
    if ccStatus is false then  onChannels.push "channelCc" else downChannels.push "channelCc"
    if phoneStatus is false then  onChannels.push "channelPhone" else downChannels.push "channelPhone"
    if smsStatus is false then  onChannels.push "channelSms" else downChannels.push "channelSms"
    if ivrStatus is false then  onChannels.push "channelIVR" else downChannels.push "channelIVR"
    if _this.data("state") is "02"
      return onChannels
    else
      return downChannels

# 一键上架
  putShelfStatusAll: (evt)->
    _this = $(@)
    code = _this.data("id")
    approveStatus =String( _this.data("status"))
    autoOffShelfTime = _this.data("auto")
    state = _this.data("state")
    channelstr=""
    if that.checkTime(autoOffShelfTime)
      if approveStatus is "06" or  approveStatus is "72" or approveStatus is "73" or approveStatus is "74"
        channels = that.getChannelHasOnShelves(_this)
        if channels.length is 0 and state is "02"
          that.alert "body", "error", "该商品没有任何渠道处于待上架状态，不允许进行一键上架操作！"
          return
        if channels.length is 0 and state is "01"
          that.alert "body", "error", "该商品没有任何渠道处于待下架状态，不允许进行一键下架操作！"
          return
        channelstr= channels.join(",")
    else
      that.alert("body", "error", "当前礼品已经自动下架，请先修改自动下架时间再进行操作！")
      return
    $.ajax
      url: Store.context + "/api/admin/goods/updateGdShelfAll"
      type: "POST"
      data:
        code: code, channels: channelstr,state:state
      success: (data)->
        that.alert "body", "success", "保存成功！"
        if state is "02"
          _this.closest("tr").find(".table-state-table").find("i").removeClass("icon-img-down").addClass("icon-img-on")
        else
          _this.closest("tr").find(".table-state-table").find("i").removeClass("icon-img-on").addClass("icon-img-down")

  checkTime: (autoOffShelfTime)->
    time = new Date(autoOffShelfTime.replace(/-/g,"/"))
    now = new Date
    return now < time

#修改库存弹框弹出事件
  editGoodsStock: (evt)->
    thisTrData = $(@).closest("tr").data("data")
    goodsCode = $(@).data("id")
    goodsName = thisTrData.goods.name
    $.ajax
      url: Store.context + "/api/admin/goods/getGoodInfo"
      type: "GET"
      dataType:"JSON"
      data:
        "goodsCode": goodsCode
      success: (data)->
        tempdata={}
        tempdata.itemList = data.data.itemList
        tempdata.goodsName = goodsName
        tempdata.goodsCode = goodsCode
        new Modal(itemStock(tempdata)).show()
        $("form.stock-form").validator
          isErrorOnParent: true
        $("form.stock-form").on "submit", that.editItemStockConfirm

#编辑库存弹框确认按钮
  editItemStockConfirm: (evt)->
    evt.preventDefault()
    data = {}
    data.itemList = []
    data.goodsCode = $(".js-goods-code").val()
    $(".js-item-tr").each ->
      item = {}
      item.code = $(@).find(".item-code").val()
      item.stock = $(@).find(".item-stock").val()
      data.itemList.push item
    $("form.stock-form").validator
      isErrorOnParent: true
    $.ajax
      url: Store.context + "/api/admin/goods/storage"
      type: "POST"
      data: {goods: JSON.stringify data}
      success: (data)->
        if(data.data)
          that.alert "body", "success", "修改库存成功！"
          window.location.reload()
        else
          that.alert "body", "error", "修改库存失败！"

  #改价modal显示
  editGoodsPrice: (evt)->
    _this = $(@)
    status = _this.parent().siblings(".status").find("td")
    goodsCode = _this.closest("div").data("code")
    goodsName = _this.closest("div").data("name")
    goodsType = _this.closest("div").data("goodstype")
    channels = that.getChannelHasOnShelves(_this)
    if channels.length isnt 5
      that.alert "body", "error", "请先将该商品在所有渠道下架后再进行操作"
      return
    else
      $.ajax
        url: Store.context + "/api/admin/pointsPresent/findGoodsPayway"
        type: "POST"
        data:
          "goodsCode": goodsCode
        success: (data)->
          data.goodsCode = goodsCode
          data.goodsName = goodsName
          data.goodsType = goodsType
          pendingModal = new Modal itemPendPriced({data: data})
          pendingModal.show()

          $("form.pend-priced-form").on "click", ".js-check-this", that.checkThis
          # 全选
          $("form.pend-priced-form").on "click", ".js-check-pendPrice", that.checkPendPrice
          $("form.pend-priced-form").on "click", ".price-review", that.saveChangePricedConfirm


  #改价提交审核
  saveChangePricedConfirm: ->
    #改价
    data = {}
    data.goodsCode = $(".goods-table").data("code")
    data.goodsPaywayDtos = []
    checkFlag = true;
    pointflag=true
    goodsType = $('.goods-type').val()
    if goodsType == "00" || goodsType == "02"
      $(".pending-table").each ->
        dto = {}
        itemId = $(@).data("itemid")
        calMoney = $(@).data("calmoney")
        dto.itemId = itemId
        dto.calMoney = calMoney
        dto.gold = $('.check-table[data-value="' + itemId + '"]').find("#checkinput2").val()
        dto.titanium = $('.check-table[data-value="' + itemId + '"]').find("#checkinput3").val()
        dto.topLevel = $('.check-table[data-value="' + itemId + '"]').find("#checkinput4").val()
        dto.vip = $('.check-table[data-value="' + itemId + '"]').find("#checkinput5").val()
        dto.birthday = $('.check-table[data-value="' + itemId + '"]').find("#checkinput6").val()
        dto.points = $('.check-table[data-value="' + itemId + '"]').find("#checkinput7").val()
        dto.price = $('.check-table[data-value="' + itemId + '"]').find("#checkinput8").val()

        data.goodsPaywayDtos.push dto
        # 价格验证
        if parseInt(dto.topLevel) >= parseInt(dto.titanium) || parseInt(dto.topLevel) >= parseInt(dto.vip)
          checkFlag = false

    else if goodsType == "01"
      $(".pending-table").each ->
        dto = {}
        itemId = $(@).data("itemid")
        calMoney = $(@).data("calmoney")
        dto.itemId = itemId
        dto.calMoney = calMoney
        dto.gold = $('.pending-table[data-itemid="' + itemId + '"]').find("#gold").val()
        #dto.points = $('.pending-table[data-itemid="' + itemId + '"]').find("#points").val()
        #dto.price = $('.pending-table[data-itemid="' + itemId + '"]').find("#price").val()
        if dto.gold is ""
          pointflag=false
        data.goodsPaywayDtos.push dto
    if !pointflag
      that.alert "body","error","请填写积分价格！"
      return
    if checkFlag
      $.ajax
        url: Store.context + "/api/admin/pointsPresent/saveChangePriced"
        type: "POST"
        data: {goods: JSON.stringify(data)}
        success: (data)->
          that.alert "body", "success", "保存成功！"
          window.location.reload()
    else
      that.alert "body", "error", "顶级/增值白金价格应低于钛金/臻享白金和VIP！"
      return

#修改价格弹出框确认按钮事件
  editItemPriceConfirm: (evt)->
    evt.preventDefault()
    $("form.price-form").validator
      isErrorOnParent: true
    data = {}
    data.itemList = []
    data.code = $(".js-goods-code").val()
    $(".js-item-price-table").each ->
      item = {}
      item.code = $(@).find(".item-code").val()
      item.marketPrice = $(@).find(".item-market").val()
      item.price = $(@).find(".item-price").val()
      item.fixPoint = $(@).find(".item-point").val()
      data.itemList.push item
    $.ajax
      url: Store.context + "/api/admin/pointsPresent/modPrice"
      type: "POST"
      data: {goods: JSON.stringify data}
      success: (data)->
        that.alert "body", "success", "提交审核成功!！"
        window.location.reload()

#全选
  checkAllGoods: (evt)->
    if $(@).is(':checked')
      $("input[name='checkGoodsItem']").prop("checked", 'checked')
    else
      $("input[name='checkGoodsItem']").prop("checked", '')

#反向全选
  checkItem: (evt)->
    if $("input[name='checkGoodsItem']:checked")
      item = $("input[name='checkGoodsItem']:checked").length;
      all = $("input[name='checkGoodsItem']").length;
      if(item == all)
        $("input[name='checkAll']").prop("checked", 'checked')
      else
        $("input[name='checkAll']").prop("checked", '')

#全选后的各项操作
  passAll: (evt)->
    evt.preventDefault()
    params = []
    operate = $(@).data("type")
    approveType = $(@).data("audit")

    cks = $("td input[type='checkbox']:checked")
    if cks.length == 0
      that.alert "body", "error", "请至少选择一条记录！"
      return false
    cks.each ->
      if $(@).data("status") is "04"
        approveType = 5
      else if  $(@).data("status") is "03"
        approveType=4
      params.push(
        code: $(@).data("code"),
        approveType: approveType,
        approveResult: operate,
        channel:"JF")
    $.ajax
      url: Store.context + "/api/admin/goods/audit-multi/jf"
      type: "POST"
      dataType: "JSON"
      contentType: "application/json"
      data: JSON.stringify(params)
      success: (data)->
        that.alert "body", "success", "保存成功！"
        window.location.reload()

  refuseAll: ->
    params = []
    operate = $(@).data("type")
    approveType = $(@).data("audit")
    cks = $("td input[type='checkbox']:checked")
    if cks.length == 0
      that.alert "body", "error", "请至少选择一条记录！"
      return false
    cks.each ->
      if $(@).data("status") is "04"
        approveType = 5
      else if  $(@).data("status") is "03"
        approveType=4
      params.push(
        code: $(@).data("code"),
        approveType: approveType,
        approveResult: operate)
    component = new Modal itemRefuse({params: params})
    component.show()
    $(document).on "submit", that.refuseAllConfirm

  refuseAllConfirm: (event)->
    event.preventDefault()
    if $("#refuseReason").val() is ""
      that.alert "body", "error", "请填写审核意见！"
      return
    paramsJson = $("#param").val()
    paramsObj = JSON.parse(paramsJson)
    $.each(paramsObj, (index, item)->
      this.approveMemo = $("#refuseReason").val()
      this.channel = "JF"
    )
    $.ajax
      url: Store.context + "/api/admin/goods/audit-multi/jf"
      type: "POST"
      dataType: "JSON"
      contentType: "application/json"
      data: JSON.stringify(paramsObj)
      success: (data)->
        that.alert "body", "success", "保存成功！"
        window.location.reload()

  submitGoodsToAudit: (evt)->
    goodsCode = $(@).data("code")
    $.ajax
      url: Store.context + "/api/admin/goods/submitGoodsToAudit"
      type: "POST"
      data:
        goodsCode: goodsCode
      success: (data)->
        that.alert "body", "success", "提交审核成功!"
        window.location.reload()


  #定价显示
  pricedPending: (evt)->
    goodsCode = $(@).closest("div").data("code")
    goodsName = $(@).closest("div").data("name")
    goodsType = $(@).closest("div").data("goodstype")
    $.ajax
      url: Store.context + "/api/admin/pointsPresent/makePrice"
      type: "POST"
      data:
        "goodsCode": goodsCode
      success: (data)->
        data.goodsCode = goodsCode
        data.goodsName = goodsName
        data.goodsType = goodsType
        pendingModal = new Modal itemPendPriced({data: data})
        pendingModal.show()
        $("form.pend-priced-form").on "click", ".js-check-this", that.checkThis
        # 全选
        $("form.pend-priced-form").on "click", ".js-check-pendPrice", that.checkPendPrice
        $("form.pend-priced-form").on "click", ".price-review", that.pricedPendingConfirm

  checkPendPrice: ->
    itemId = $(@).data("value")
    if $('.js-check-pendPrice[data-value="' + itemId + '"]').is(':checked')
      $('input[name=checkPendPrice][data-value="' + itemId + '"]').prop("checked", 'checked')
      $('input[name=checkinput][data-value="' + itemId + '"]').prop("disabled", '')
    else
      $('input[name=checkPendPrice][data-value="' + itemId + '"]').prop("checked", '')
      $('input[name=checkinput][data-value="' + itemId + '"]').prop("disabled", 'disabled')

  checkThis: ->
    itemId = $(@).data("value")
    checkbox = $(@).val()
    if $(@).is(':checked')
      $(@).prop("checked", 'checked')
      if checkbox is "checkbox2"
        $('#checkinput2[data-value="' + itemId + '"]').prop("disabled", '')
      else if checkbox is "checkbox3"
        $('#checkinput3[data-value="' + itemId + '"]').prop("disabled", '')
      else if checkbox is "checkbox4"
        $('#checkinput4[data-value="' + itemId + '"]').prop("disabled", '')
      else if checkbox is "checkbox5"
        $('#checkinput5[data-value="' + itemId + '"]').prop("disabled", '')
      else if checkbox is "checkbox6"
        $('#checkinput6[data-value="' + itemId + '"]').prop("disabled", '')
      else if checkbox is "checkbox7"
        $('#checkinput7[data-value="' + itemId + '"]').prop("disabled", '')
        $('#checkinput8[data-value="' + itemId + '"]').prop("disabled", '')
    else
      $(@).prop("checked", '')
      if checkbox is "checkbox2"
        $('#checkinput2[data-value="' + itemId + '"]').prop("disabled", 'disabled')
      else if checkbox is "checkbox3"
        $('#checkinput3[data-value="' + itemId + '"]').prop("disabled", 'disabled')
      else if checkbox is "checkbox4"
        $('#checkinput4[data-value="' + itemId + '"]').prop("disabled", 'disabled')
      else if checkbox is "checkbox5"
        $('#checkinput5[data-value="' + itemId + '"]').prop("disabled", 'disabled')
      else if checkbox is "checkbox6"
        $('#checkinput6[data-value="' + itemId + '"]').prop("disabled", 'disabled')
      else if checkbox is "checkbox7"
        $('#checkinput7[data-value="' + itemId + '"]').prop("disabled", 'disabled')
        $('#checkinput8[data-value="' + itemId + '"]').prop("disabled", 'disabled')


  #定价提交审核
  pricedPendingConfirm: ->
    data = {}
    data.goodsCode = $(".goods-table").data("code")
    data.goodsPaywayDtos = []
    checkFlag = true;
    goodsType = $('.goods-type').val()
    priceflag=true
    if goodsType == "00" || goodsType == "02"
      $(".pending-table").each ->
        dto = {}
        itemId = $(@).data("itemid")
        calMoney = $(@).data("calmoney")
        dto.itemId = itemId
        dto.calMoney = calMoney
        dto.gold = $('.check-table[data-value="' + itemId + '"]').find("#checkinput2").val()
        dto.titanium = $('.check-table[data-value="' + itemId + '"]').find("#checkinput3").val()
        dto.topLevel = $('.check-table[data-value="' + itemId + '"]').find("#checkinput4").val()
        dto.vip = $('.check-table[data-value="' + itemId + '"]').find("#checkinput5").val()
        dto.birthday = $('.check-table[data-value="' + itemId + '"]').find("#checkinput6").val()
        dto.points = $('.check-table[data-value="' + itemId + '"]').find("#checkinput7").val()
        dto.price = $('.check-table[data-value="' + itemId + '"]').find("#checkinput8").val()

        data.goodsPaywayDtos.push dto
        # 价格验证
        if parseInt(dto.topLevel) >= parseInt(dto.titanium) || parseInt(dto.topLevel) >= parseInt(dto.vip)
          checkFlag = false
    else if goodsType == "01"
      $(".pending-table").each ->
        dto = {}
        itemId = $(@).data("itemid")
        calMoney = $(@).data("calmoney")
        dto.itemId = itemId
        dto.calMoney = calMoney
        dto.gold = $('.pending-table[data-itemid="' + itemId + '"]').find("#gold").val()
        #dto.points = $('.pending-table[data-itemid="' + itemId + '"]').find("#points").val()
        #dto.price = $('.pending-table[data-itemid="' + itemId + '"]').find("#price").val()
        if dto.gold is ""
          priceflag=false
        data.goodsPaywayDtos.push dto
    if !priceflag
      that.alert "body", "error", "请填写纯积分价格！"
      return
    if checkFlag
      $.ajax
        url: Store.context + "/api/admin/pointsPresent/pengingPriced"
        type: "POST"
        data: {goods: JSON.stringify(data)}
        success: (data)->
          that.alert "body", "success", "保存成功！"
          window.location.reload()
    else
      that.alert "body", "error", "定价错误！"
      return

  #定价审核MODAL显示
  reviewedPriced: ->
    goodsCode = $(@).closest("div").data("code")
    goodsName = $(@).closest("div").data("name")
    goodsType = $(@).closest("div").data("goodstype")
    goodsStatus = $(@).closest("div").data("status")
    $.ajax
      url: Store.context + "/api/admin/pointsPresent/findChangePriceInfo"
      type: "POST"
      data:
        "goodsCode": goodsCode
      success: (data)->
        data.goodsCode = goodsCode
        data.goodsName = goodsName
        data.goodsType = goodsType
        pendingModal = new Modal itemPriceReviewed({data: data})
        pendingModal.show()
        $("form.price-reviewed-form").on "click", '.js-exam-pass', ->
          that.reviewedPricedConfirm(goodsStatus, $(@))
        $("form.price-reviewed-form").on "click", '.js-exam-reject', ->
          that.reviewedPricedConfirm(goodsStatus, $(@))




  #定价审核通过/拒绝
  reviewedPricedConfirm: (goodsStatus, self)->
    ###礼品定价审核 type=8   变更审核 type=5###
    approveType=""
    if goodsStatus is '08' then approveType = '8' else approveType = '5'
    presentCode = $(".goods-table").data("code")
    approveResult = self.data("result")
    approveMemo = $(".js-approve-memo").val()
    if approveResult is "reject" && approveMemo is ""
      that.alert "body", "error", "请填写审核意见！"
      return
#    if approveMemo isnt ""
#      if /[~'!@#$%&*()-+_=:]/.test approveMemo
#        that.alert "body", "error", "审核意见不允许输入特殊字符！"
#        return
    params={}
    params.code = presentCode #商品编码
    params.approveType = approveType #审核类型
    params.approveResult = approveResult #审核结果 通过值为pass,拒绝 reject
    params.approveMemo = approveMemo #审核意见
    params.channel = "JF"
    $.ajax
      url: Store.context + "/api/admin/goods/audit/#{presentCode}"
      type: "POST"
      data:params
      success: (data)->
        that.alert "body", "success", "审核完成！"
        location.href = Store.context + "/points/item/all-present"

  remainingText: ->
    val = $("#descript").val()
    length = parseInt(val.length)
    text = 200 - length
    if length >= 200
      $(@).val(val.substr(0, 200))
      text = 0
    $(".remaining-text i").text(text)

  ##多件商品一键上架 FROM 追加 多件商品一键上架 陈乐 2016.11.1 2016.11.1  --}}
  putShelfAll:->
    cks = $("td input[name='checkGoodsItem']:checked")
    if cks.length == 0
      that.alert "body", "error", "请至少选择一条记录！"
      return
    channelcks = $("input[name='channel']:checked")
    if channelcks.length == 0
      that.alert "body", "error", "请选择渠道！"
      return
    autoFlag=true
    cks.each ->
      if !that.checkTime($(@).data("auto"))
        autoFlag = false
    if !autoFlag
      that.alert "body", "error", "存在已自动下架的礼品，请剔除后重试！"
      return
    status=""
    if $(@).data("type")+"" is "5" then status="02" else status="01"
    channels=""
    channelArr=[]
    channelcks.each ->
      channelArr.push $(@).data("channel")
    channels = channelArr.join(",")
    array = []
    cks.each ->
      array.push $(@).data("code")
    $.ajax
      url: Store.context + "/api/admin/goods/updateGdShelf"
      type: "POST"
      data: array: array,channels:channels,status:status
      success:(data)->
        if data.data > 0
          that.alert "body", "success", "操作成功!"
        else
          that.alert "body", "success", "操作失败!"
        window.location.reload()

##多件商品一键上架 TO 追加 多件商品一键上架 陈乐 2016.11.1 2016.11.1  --}}



module.exports = PresentManage