Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"

class ItemManage
  _.extend @::, TipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show();

  constructor: ->
    @putShelfBtn = ".js-put-shelf" #上下架按钮
    @select1 = ".js-select1" #后台类目一级
    @select2 = ".js-select2" #后台类目二级
    @editStock = ".js-edit-stock" #修改库存按钮
    @checkAll = ".js-all-check" #全选按钮
    @checkThisItem = ".js-check-this" #列表页每一行前面的checkbox
    @allPass = ".js-all-pass" #全选通过
    @allRefuse = ".js-all-refuse" #全选拒绝
    @submitGoodsBtn = ".js-submit-goods" #提交按钮
    @$exportItemBtn = $(".js-export") #导出按钮
    @$itemSearchBtn = $(".js-item-search")
    @shelfStatusAll = ".js-shelfStatus-all" #一键上架
    @downShelfAll = ".js-shelf-down-all" #一键下架
    @editGoodsBtn = $(".js-edit-goods")
    @putShelfAllBtn=".js-all-shelf" #全选后上下架按钮
    @jsImportBtn = $(".js-import")
    @importItemBtn = ".js-import-btn" #上传按钮
    @fileSelectBtn = ".js-file-select" #文件选择按钮

    @bindEvent()
    @backCategoryInit()
  that = this
  itemStock = App.templates['item_stock']
  itemRefuse = App.templates['item_refuse']
  itemImport = App.templates['item_import']
  itemImportResult = App.templates['items_import_result']
  itemSelectTemplate = App.templates["item_select"]

  #绑定事件
  bindEvent: ->
    that = this
    @jsImportBtn.on "click",@showImportModal
    @$exportItemBtn.on "click", @exportItemData
    @$itemSearchBtn.on "click", @exportItemData
    @editGoodsBtn.on "click", @editGoods
    $(".item").on "click", @putShelfBtn, @putShelfStatus #点击上下架图标，将该渠道下架
    $(".item").on "click", @shelfStatusAll, @putShelfStatusAll #点击一键上架，上架所有渠道
    $(".item").on "click", @downShelfAll, @putShelfStatusAll #点击一键下架，下架所有渠道
    $(".item").on "click", @editStock, @editGoodsStock #点击库存按钮，弹出编辑库存的弹框
    $(".item").on "click", @checkAll, @checkAllGoods #全选按钮事件
    $(".item").on "click", @allPass, @passAll #全选后操作事件
    $(".item").on "click", @allRefuse, @refuseAll #全选后操作事件
    $(".item").on "click", @checkThisItem, @checkItem #反向全选事件
    $(".item").on "click", @submitGoodsBtn, @submitGoodsToAudit
    $(".item").on "change", @select1, ->
      that.selectCategory($(@), null, null, null)
    $(".item").on "change", @select2, ->
      that.selectCategory($(@), null, null, null)
    ##多件商品一键上架 FROM 追加 多件商品一键上架 陈乐 2016.11.1 2016.11.1  --}}
    $(".item").on "click",@putShelfAllBtn,@putShelfAll
    ##多件商品一键上架 TO 追加 多件商品一键上架 陈乐 2016.11.1 2016.11.1  --}}
    $(document).on "click",@importItemBtn,@importFormSubmit
    $(document).on "change",@fileSelectBtn,@fileSelect



  showImportModal:->
    importModal = new Modal itemImport(context: Store.context)
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
    $(".js-import-form").attr("action", "/mmc/api/admin/item/importGoodsData")
    $(".js-import-form").attr("enctype", "multipart/form-data")
    $("form.js-import-form").submit()


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
      url: Store.context + "/api/admin/backCategories/#{parentId}/children?channel=YG"
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

  editGoods: (evt)->
    goodsCode = $(@).data("goods-code")
    spuId = $(@).data("spu-id")
    $.ajax
      url: Store.context + "/api/admin/promotion/findItemInActivity"
      type: "POST"
      data:
        "goodsCode": goodsCode
      success: (data)->
        if data.data is false
          that.alert "body", "error", "当前商品已参加活动，不允许修改！"
        else
          window.location.href = Store.context + "/mall/item/edit-goods?goodsCode=#{goodsCode}&spuId=#{spuId}"


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



  importItemTemp: (evt)->
    importModal = new Modal itemImport(context: Store.context)
    importModal.show()



  checkTime: (autoOffShelfTime)->
    time = new Date(autoOffShelfTime.replace(/-/g,"/"))
    now = new Date
    return now < time

  putShelfStatus: (evt)->
    #获取渠道
    _this = $(@)
    autoOffShelfTime = $(@).closest(".table-state").data("auto")
    channel = _this.parent().data("channel")
    code = _this.parent().parent().parent().parent().data("code") #获取商品编码
    array=[]
    array.push code
    state = ""
    if _this.hasClass("icon-img-on") then state = "02" else state = "01"
    approveStatus = String(_this.parent().parent().parent().parent().data("status"))
    if approveStatus is "06" or approveStatus is "72" or approveStatus is "73" or approveStatus is "74"
      if state is '01'
        if that.checkTime(autoOffShelfTime)
          changeState = '02'
        else
          that.alert "body", "error", "当前商品已经自动下架，无法上架，请修改自动下架时间！"
          return
      else changeState = '01'
      $.ajax
        url: Store.context + "/api/admin/goods/updateGdShelf"
        type: "POST"
        data:  array: array,channels:channel,status:changeState
        success: (data)->
          that.alert "body", "success", "保存成功！"
          if state is '01'
            _this.removeClass("icon-img-down").addClass("icon-img-on")
          else
            _this.removeClass("icon-img-on").addClass("icon-img-down")
        error: (data) ->
          new Modal(
            icon: "error"
            title: "出错啦！"
            content: data.responseText || "未知故障"
            overlay: false)
          .show()
    else
      that.alert "body", "error", "请等待审核完成后再进行操作！"


  getChannelHasOnShelves: (_this)->
    onChannels = []
    downChannels = []
    mallStatus = _this.closest("tr").find(".js-chennel-mall").find("i").hasClass("icon-img-on") #广发商城渠道状态
    ccStatus = _this.closest("tr").find(".js-channel-cc").find("i").hasClass("icon-img-on") #CC渠道状态
    mallWxStatus = _this.closest("tr").find(".js-mall-wx").find("i").hasClass("icon-img-on") #微信广发银行渠道状态
    phoneStatus = _this.closest("tr").find(".js-channel-phone").find("i").hasClass("icon-img-on") #手机银行渠道状态
    creditWxStatus = _this.closest("tr").find(".js-credit-wx").find("i").hasClass("icon-img-on") #微信广发信用卡渠道状态
    appStatus = _this.closest("tr").find(".js-channel-app").find("i").hasClass("icon-img-on") #APP渠道状态
    smsStatus = _this.closest("tr").find(".js-channel-sms").find("i").hasClass("icon-img-on") #短信渠道状态
    if mallStatus is false then  onChannels.push "channelMall" else downChannels.push "channelMall"
    if ccStatus is false then  onChannels.push "channelCc" else downChannels.push "channelCc"
    if mallWxStatus is false then  onChannels.push "channelMallWx" else downChannels.push "channelMallWx"
    if phoneStatus is false then  onChannels.push "channelPhone" else downChannels.push "channelPhone"
    if creditWxStatus is false then  onChannels.push "channelCreditWx" else downChannels.push "channelCreditWx"
    if appStatus is false then  onChannels.push "channelApp" else downChannels.push "channelApp"
    if smsStatus is false then  onChannels.push "channelSms" else downChannels.push "channelSms"
    if _this.data("state") is "02"
      return onChannels
    else
      return downChannels


  putShelfStatusAll: (evt)->
    _this = $(@)
    code = _this.data("id")
    approveStatus = String(_this.data("status"))
    autoOffShelfTime = _this.data("auto")
    state = _this.data("state")
    if that.checkTime(autoOffShelfTime) is false and state is "02"
      that.alert "body", "error", "当前商品已经自动下架，请修改自动下架时间后再进行操作哦！"
      return
    if approveStatus is "06" or approveStatus is "72" or approveStatus is "73" or approveStatus is "74"
      channels = that.getChannelHasOnShelves(_this)
      if channels.length is 0 and state is "02"
        that.alert "body", "error", "该商品没有任何渠道处于待上架状态，不允许进行一键上架操作！"
        return
      if channels.length is 0 and state is "01"
        that.alert "body", "error", "该商品没有任何渠道处于待下架状态，不允许进行一键下架操作！"
        return
      channelstr = channels.join(",")#渠道
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
        error: (data) ->
          new Modal(
            icon: "error"
            title: "出错啦！"
            content: data.responseText || "未知故障"
            overlay: false)
          .show()
    else
      that.alert "body", "error", "请等待审核完成后再进行操作！"


#修改库存弹框弹出事件
  editGoodsStock: (evt)->
    thisTrData = $(@).closest("tr").data("data")
    goodsCode = $(@).data("id")
    goodsName = thisTrData.goods.name
    $.ajax
      url: Store.context + "/api/admin/goods/getGoodInfo"
      type: "GET"
      data:
        "goodsCode": goodsCode
      success: (data)->
        tempdata = {}
        tempdata.itemList = data.data.itemList
        tempdata.goodsName = goodsName
        tempdata.goodsCode = goodsCode
        stockModal = new Modal itemStock(tempdata)
        stockModal.show()
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
        that.alert "body", "success", "修改库存成功！"
        window.location.reload()
      error: (data) ->
        new Modal(
          icon: "error"
          title: "出错啦！"
          content: data.responseText || "未知故障"
          overlay: false)
        .show()



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
    approveType = $(@).data("audit")
    params = []
    approveResult = $(@).data("type")
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
        approveResult: approveResult,
        channel:"YG")
    $.ajax
      url: Store.context + "/api/admin/goods/audit-multi/yg"
      type: "POST"
      dataType: "JSON"
      data: JSON.stringify(params)
      contentType: "application/json"
      success: (data)->
        that.alert "body", "success", "保存成功！"
        window.location.reload()

  refuseAll: ->
    params = []
    approveResult = $(@).data("type")
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
        approveResult: approveResult)
    component = new Modal itemRefuse({params: params})
    component.show()
    $(document).on "submit", that.refuseAllConfirm

  refuseAllConfirm: (evt) ->
    evt.preventDefault()
    paramsJson = $("#param").val()
    paramsObj = JSON.parse(paramsJson)
    reason = $("#refuseReason").val()
    if reason is ""
      that.alert "body", "error", "请填写审核意见！"
      return
    if reason.length > 100
      that.alert "body", "error", "审核意见最多可输入100个字符！"
      return
    $.each(paramsObj, (index, item)->
      this.approveMemo = reason
      this.channel = "YG"
    )
    $.ajax
      url: Store.context + "/api/admin/goods/audit-multi/yg"
      type: "POST"
      dataType: "JSON"
      data: JSON.stringify(paramsObj)
      contentType: "application/json"
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
      that.alert "body", "error", "存在已自动下架的商品，请剔除后重试！"
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

module.exports = ItemManage