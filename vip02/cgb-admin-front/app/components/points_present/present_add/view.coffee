Modal = require "spirit/components/modal"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"
image = require("extras/image")

recomTemp = App.templates['recommend_goods'] #关联推荐商品模板
recomSearchResultTemp = App.templates['recommend_goods_search_result'] #关联推荐商品查询结果模板
recomResultTemp = App.templates['recommend_goods_result']
presentRegionTrTemp = App.templates["present_region_tr"] ##分区内容选择模块

spuTemplate = App.templates["item_spu_properties"]
skuTemplate = App.templates["item_sku_properties"]
tableTemplate = App.templates["present_table"]
singleColumnTableTemplate = App.templates["present_single_column_table"]
vendorListTemplate = App.templates["vendor_list"]
itemImageTemplate = App.templates["item_image"]

class presentAdd
  _.extend @::, TipAndAlert

  recomOrders = null
  imgOrders = null
  checkAttrFlag = true ## 属性重复check
  checkAttrSelectFlag = true ## 属性重复选择check
  attrChecked = false ## 是否勾选属性
  vendorId = null
  attrModal = null
  attrsList = [] #定义全局变量，用于存放单品属性集合

  constructor: ->
#引入富文本编辑器
    text = $('.js-introduction').data('introduction')
    require.async([ '/static/umeditor/umeditor.config.js','/static/umeditor/umeditor.min.js'], (a)->
      um = UM.getEditor('myEditor', {
        zIndex: 99
      });
      um.addListener "ready", ->
        um.setContent(text)
    )
    @delRecomBtn = ".js-recom-del"
    @selectRecomBtn = ".js-recom-select"
    @$localOrderBtn = $(".js-local-order") #订单流程，绑定按钮事件
    @adWordAreatext = ".js-adWord" # 礼品卖点
    @giftDescAreatext = ".js-giftDesc" # 赠品信息
    @spuId = $(".present-add-form").data("spu-id")
    @vendorId = $(".present-add-form").data("vendor-id")
    @preSentForm = ".present-add"
    @skusCheckbox = ".skus .sku-value"
    @oldStockValues = {}
    @oldPriceValues = {}
    @imagesUploadButton = $("#replace-image-button")
    @itemAdd = ".item-add"
    @jsImageUpload = ".js-image-upload"
    @imageReplace = ".image-replace"
    @jsSearchRedionType = ".js-search-redionType"
    @regionType = ".region-type"
    @vendorSelectBtn = (".js-vendor-select")
    @searchRecomBtn = ".js-recom-search"
    @saveRecomBtn = ".js-recom-sure"
    @delIconBtn = ".js-del-icon"
   # @setYear()
    @bindEvent()
  that = this

  bindEvent: ->
    that = this
    $(document).on "click",@delIconBtn,@delImage
    @$localOrderBtn.on "click", @localOrder #订单流程，绑定按钮事件
    $(@preSentForm).on "click", @delRecomBtn, @delRecommendGoods
    $(@preSentForm).on "click", @selectRecomBtn, @selectRecommendGoods #点击选择，弹出关联推荐礼品弹框
    $(@preSentForm).on "keydown keyup keypress", @adWordAreatext, ->
      that.areaTextListener(80, $(@)) ## 监听area显示可输入字数
    $(@preSentForm).on "blur", @adWordAreatext, ->
      that.areaTextListener(80, $(@)) ## 监听area显示可输入字数
    $(@preSentForm).on "keydown keyup keypress", @giftDescAreatext, ->
      that.areaTextListener(100, $(@)) ## 监听area显示可输入字数
    $(@preSentForm).on "blur", @giftDescAreatext, ->
      that.areaTextListener(100, $(@)) ## 监听area显示可输入字数
    $(@preSentForm).on "submit", @savePresent
    @imagesUploadButton.on "click", @imagesUpload
    $(@preSentForm).on "click", @jsImageUpload, @itemImagesUpload
    $(@preSentForm).on "click", @imageReplace, @replaceImage
    $(@preSentForm).on "keyup", @jsSearchRedionType, @redionSearchItem
    $(@preSentForm).on "change", @regionType, @regionTypeChange
    $(document).on "change", @skusCheckbox, @skusCheckboxChange

    #$(@preSentForm).on "change", @vendorSelectBtn, @vendorSelect
    #setVendors(@vendorId)
    @setSpus(@spuId)
    @presentRegion()
    $(@preSentForm).validator
      isErrorOnParent: true


  delImage:->
    imageList = $(@).closest(".image-ul")
    $(@).closest(".item-image-li").remove()
    if $(".js-image-upload").length < 1 and imageList.find("li").length < 5
      imageList.append(itemImageTemplate())

  checkTime: (autoOffShelfTime)->
    time = new Date(autoOffShelfTime.replace(/-/g,"/"))
    now = new Date
    return now < time

  savePresent: (evt)->
    evt.preventDefault()
    $("form.present-add-form").validator
      isErrorOnParent: true

    #服务承诺字段
    servicePromise = [];
    $("input[name='servicePromise']:checkbox").each ->
      if($(@).prop("checked"))
        servicePromise.push $(@).val()
    @services = ""
    if servicePromise.length > 0
      @services = servicePromise.join(",")
    recommendGoodsCodes = []
    #关联推荐商品
    if $(".recommend-li").length isnt 0
      $(".recommend-li").each ->
        recommendGoodsCodes.push $(@).data("code")
    #校验第三级卡产品编码
    count=0;
    if $("input[name=cards]").val() is "WWWW"
      count++;
    if /^(\d{4}\,)*?\d{4}$/.test( $("input[name=cards]").val())
      count++;
    if count isnt 1
      $("input[name=cards]").focus()
      that.tip($("input[name=cards]").parent(), "error", "up", "输入格式不正确")
      $(".tip").css("left",150).css("top", 30)
      return
    #校验自动下架时间
    if !that.checkTime($("input[name=autoOffShelfTime]").val())
      that.alert "body", "error", "自动下架时间不能小于当前日期！"
      return
    data = goods:
      code: $("input[name=code]").val()
      productId: that.spuId #产品Id
      vendorId: $("select[name=vendorId]").val()#供应商id
      name: $("input[name=goodsName]").val()#商品名
      manufacturer: $("input[name=manufacturer]").val()  #厂家
      goodsType: if $("input[name=goodsType]:checked").length isnt 0 then $("input[name=goodsType]:checked").val() else $("input[name=goodsType]").val() # 商品类型
      isInner: $("input[name=isInner]:checked").val()  #是否内宣
      regionType: $("select[name=regionType]").val()# 分区
      pointsType: $("input[name=pointsType]").data("id") #积分类型
      autoOffShelfTime: $("input[name=autoOffShelfTime]").val() #自动下架时间
      cards: $("input[name=cards]").val() #卡编码
      cardLevelId: $("select[name=cardsLevel]").val() #卡等级
      limitCount:$("input[name=monthLimited]").val() #当月限购数量
      adWord: $("textarea[name=adWord]").val()#卖点
      giftDesc: $("textarea[name=giftDesc]").val()#赠品
      introduction: UM.getEditor('myEditor').getContent()#获取富文本编辑器内容
      serviceType: @services
    data.recommendGoodsCodes = recommendGoodsCodes.join(",")
    data.isShow = $("input[name=isDisplay]:checked").val()
    skuList = that.fetchSKUList()
    if skuList.length is 0
      that.alert "body", "error", "请至少添加一条销售属性！"
      return
    list = []
    imageFlag=true
    if skuList.length is 1
      _.each $(".skus-table tbody tr"), (tr) ->
        columnKey = $(".skus-table thead th:first").text()
        columnId = $("td.column", tr).data("id")
        columnName = $("td.column", tr).data("name")
        code = $("td input[name=stock]", tr).data("db-id")
        xid = $(tr).data("item-xid") ## xid 审核时数据显示 add by zhoupeng
        virtualPrice = $("td input[name=virtualPrice]", tr).val()
        virtualMileage = $("td input[name=virtualMileage]", tr).val()
        prefucture = $("td select[name=prefucture]", tr).val()
        bid = $("td input[name=bid]", tr).val()
        virtualIntegralLimit = $("td input[name=virtualIntegralLimit]", tr).val()
        price = $("td input[name=price]", tr).val()
        stock = $("td input[name=stock]", tr).val()
        stockWarning = $("td input[name=stockWarning]", tr).val()
        o2oCode = $("td input[name=o2oCode]", tr).val()
        voucher = $("td input[name=voucher]", tr).val()
        cardLevelId = $("select[name=cardsLevel]").val() #卡等级
        images = []
        if $(".js-item-image ").length<1
          imageFlag = false
        _.each $("td .image-ul", tr).find("li"), (data) ->
          images.push($(data).find("img").attr("src"))
        image1 = if images[0] then  images[0] else ""
        image2 = if images[1] then  images[1] else ""
        image3 = if images[2] then  images[2] else ""
        image4 = if images[3] then  images[3] else ""
        image5 = if images[4] then  images[4] else ""
        ## 限时抢购
        if prefucture is "0"
          virtualLimit = 0
          virtualLimitDays = 0
        else if prefucture is "1"
          virtualLimit = 1
          virtualLimitDays = 365
        else if prefucture is "2"
          virtualLimit = 1
          virtualLimitDays = 180
        else if prefucture is "3"
          virtualLimit = 2
          virtualLimitDays = 365
        list.push
          attributeKey1: columnKey
          attributeName1: columnName
          attributeValue1: columnId
          code:code
          xid:xid
          price: price
          stockWarning: stockWarning
          stock: stock
          virtualMileage: virtualMileage
          virtualLimit: virtualLimit
          virtualLimitDays:virtualLimitDays
          virtualPrice: virtualPrice
          bid: bid
          virtualIntegralLimit: virtualIntegralLimit
          o2oCode: o2oCode
          o2oVoucherCode: voucher
          cardLevelId:cardLevelId
          image1: image1
          image2: image2
          image3: image3
          image4: image4
          image5: image5

    else
      mainColumnKey = undefined
      mainColumnName = undefined
      mainColumnId = undefined
      _.each $(".skus-table tbody tr"), (tr) ->
        unless $("td.main-column", tr).attr("rowspan") is undefined
          mainColumnKey = $(".skus-table thead th:first").text()
          mainColumnName = $("td.main-column", tr).data("name")
          mainColumnId = $("td.main-column", tr).data("id")
        columnKey = $(".skus-table thead th:nth-child(2)").text()
        columnId = $("td.column", tr).data("id")
        columnName = $("td.column", tr).data("name")
        code = $("td input[name=stock]", tr).data("db-id")
        xid = $(tr).data("item-xid") ## xid 审核时数据显示 add by zhoupeng
        virtualPrice = $("td input[name=virtualPrice]", tr).val()
        virtualMileage = $("td input[name=virtualMileage]", tr).val()
        prefucture = $("td select[name=prefucture]", tr).val()
        bid = $("td input[name=bid]", tr).val()
        virtualIntegralLimit = $("td input[name=virtualIntegralLimit]", tr).val()
        price = $("td input[name=price]", tr).val()
        stock = $("td input[name=stock]", tr).val()
        stockWarning = $("td input[name=stockWarning]", tr).val()
        o2oCode = $("td input[name=o2oCode]", tr).val()
        voucher = $("td input[name=voucher]", tr).val()
        cardLevelId = $("select[name=cardsLevel]").val() #卡等级
        images = []
        if $(".js-item-image ").length<1
          imageFlag = false
        _.each $("td .image-ul", tr).find("li"), (data) ->
          images.push($(data).find("img").attr("src"))
        image1 = if images[0] then  images[0] else ""
        image2 = if images[1] then  images[1] else ""
        image3 = if images[2] then  images[2] else ""
        image4 = if images[3] then  images[3] else ""
        image5 = if images[4] then  images[4] else ""
        ## 限时抢购
        if prefucture is "0"
          virtualLimit = 0
          virtualLimitDays = 0
        else if prefucture is "1"
          virtualLimit = 1
          virtualLimitDays = 365
        else if prefucture is "2"
          virtualLimit = 1
          virtualLimitDays = 180
        else if prefucture is "3"
          virtualLimit = 2
          virtualLimitDays = 365
        list.push
          attributeKey1: mainColumnKey
          attributeName1: mainColumnName
          attributeValue1: mainColumnId
          attributeKey2: columnKey
          attributeName2: columnName
          attributeValue2: columnId
          code:code
          xid:xid
          price: price
          stockWarning: stockWarning
          stock: stock
          virtualLimit: virtualLimit
          virtualLimitDays:virtualLimitDays
          virtualMileage: virtualMileage
          virtualPrice: virtualPrice
          bid: bid
          virtualIntegralLimit: virtualIntegralLimit
          o2oCode: o2oCode
          o2oVoucherCode: voucher
          cardLevelId:cardLevelId
          image1: image1
          image2: image2
          image3: image3
          image4: image4
          image5: image5
    if imageFlag is false
      that.alert "body","error", "请为每条单品上传图片！"
      return
    data.itemList = list
    b = that.isAllFilled(1)
    if b is false
      return
    isPriceFlag=that.isPrice()
    if isPriceFlag is false
      return
    isNumberFlag=that.isNumber()
    if isNumberFlag is false
      return
    type = $('input[name="addType"]').val()
    if b is true
      $("body").spin("medium")
      postUrl = ""
      if data.goods.code
        postUrl = "/api/admin/goods/update/#{data.goods.code}"
      else
        postUrl = "/api/admin/goods/addGoods"
      $.ajax
        url: Store.context + postUrl
        type: "POST"
        data:
          goods: JSON.stringify data
          type: type
          channel: "JF"
        success: (data)->
          window.location.href = Store.context + "/points/item/all-present"

  vendorSelect: ->
    vendorRole = $(@).find("option:selected").data("vendorrole")
    if vendorRole is 3
      $("input[name=localOrder][value=00]").parent("label").hide()
      $("input[name=localOrder][value=01]").parent("label").hide()
      $("input[name=localOrder][value=02]").parent("label").show()
      $("input[name=localOrder][value=02]").prop("checked", true)
    else
      $("input[name=localOrder][value=00]").parent("label").show()
      $("input[name=localOrder][value=00]").prop("checked", true)
      $("input[name=localOrder][value=01]").parent("label").show()
      $("input[name=localOrder][value=02]").parent("label").hide()

  redionSearchItem: ->
    if($(this).val())
      $(@).closest(".search-item-group").find(".redion-value").prop("selected", false).hide().filter(":contains('" + ( $(this).val() ) + "')").prop("selected", true)
    else
      $(@).closest(".search-item-group").find(".redion-value").show()
    that.regionTypeChange()

  regionTypeChange: ->
    $("input[name=pointsType]").data("id", $(".region-type").find("option:selected").data("integ-id"))
    $("input[name=pointsType]").val($(".region-type").find("option:selected").data("integ-name"))
    $("input[name=cards]").val($(".region-type").find("option:selected").data("cards"))
    $("input[name=areaId]").val($(".region-type").find("option:selected").data("area-id"))

  imagesUpload: (evt)->
    evt.preventDefault()
    image.selector().done (image_url) ->
      $(".main-image img").attr "src", image_url

  replaceImage: (evt)->
    evt.preventDefault()
    imageList = $(@).closest(".image-replace")
    image.selector().done (image_url) ->
      imageList.find("img").attr "src", image_url

  itemImagesUpload: (evt)->
    evt.preventDefault()
    imageList = $(@).closest(".image-ul")
    image.selector().done (image_url) ->
      imageList.find(".upload-image").remove()
      imageList.append(itemImageTemplate(image: image_url))
      if(imageList.find("li").length < 5)
        imageList.append(itemImageTemplate())

  setVendors: (vendorId)->
    if vendorId
      $.get Store.context + "/api/admin/cooperation/#{vendorId}", (data) ->
        $(".js-vendor-list").append(vendorListTemplate(data: data.data.result, type: 2))
    else
      $.get Store.context + "/api/admin/cooperation/list?channel=JF", (data)->
        $(".js-vendor-list").append(vendorListTemplate(data: data.data.result, type: 1))

  setSpus: (spuId)->
    $.get Store.context + "/api/admin/spuDetail/#{spuId}", (data)->
      $(".spu").append(spuTemplate({data: data.data.spuAttributes}))
      that.setSku(data)
    @setServicePromise()

  setServicePromise: ->
    serviceType = $(".service-promise").data("service-promise")
    servicePromiseTemplate = App.templates["service_promise"]
    $.get Store.context + "/api/admin/servicePromise", (data) ->
      $(".service-promise").append(servicePromiseTemplate(data: data.data))
      if serviceType
        _.each String(serviceType).split(","), (v) ->
          $("input[name=servicePromise][value=#{v}]").prop "checked", true

  setSku: (data)->
    if !$(".skus").data("skus")
      $(".skus").append(skuTemplate({data: data.data.skuAttributes, type: 1}))
    else
      $(".skus").append(skuTemplate({data: $(".item-add .control-group .skus").data("sku-group"), type: 2}))
    selectedSkus = $(".item-add .control-group .skus").data("skus")
    approveStatus = $("form.present-add-form").data("approve-status") + ""
    if selectedSkus
      $.each selectedSkus, (i, d)->
        skus1 = $(".attr-label[data-name=" + d.attributeKey1 + "]").closest(".attr")
        skus2 = $(".attr-label[data-name=" + d.attributeKey2 + "]").closest(".attr")
        skus1.find(".sku-value[data-id=" + d.attributeValue1 + "]").prop "checked", true
        skus2.find(".sku-value[data-id=" + d.attributeValue2 + "]").prop "checked", true
        $(".sku-value").attr "disabled", true
        that.skusCheckboxChange()
      $.each selectedSkus, (i, d)->
        thisTr = $(".skus-table tbody").find("tr")[i]
        $(thisTr).find("input[name=stock]").attr("data-db-id", d.id)
        $(thisTr).attr("data-item-xid", d.xid) ## 赋值 item xid add by zhoupeng
        $(thisTr).find("input[name=stock]").val(d.stock)
        $(thisTr).find("input[name=price]").val(d.price)
        ## 允许 改价的只有 编辑中、初审复审拒绝的情况
        if approveStatus isnt "00" and approveStatus isnt "70" and approveStatus isnt "71"
          $(thisTr).find("input[name=price]").attr("disabled", true)
        $(thisTr).find("input[name=stockWarning]").val(d.stockWarning)
        $(thisTr).find("input[name=virtualPrice]").val(d.virtualPrice)
        $(thisTr).find("input[name=virtualMileage]").val(d.virtualMileage)
        prefucture = that.setPrefucture(d)
        $(thisTr).find("select[name=prefucture]").val(prefucture)
        $(thisTr).find("input[name=bid]").val(d.bid)
        $(thisTr).find("input[name=virtualIntegralLimit]").val(d.virtualIntegralLimit)
        $(thisTr).find("input[name=o2oCode]").val(d.o2oCode)
        $(thisTr).find("input[name=voucher]").val(d.o2oVoucherCode)
        that.selectedImages(thisTr, d)
    else
      that.skusCheckboxChange()

  setPrefucture:(d)->
    prefucture = "0"
    if d.virtualLimit is 1 and d.virtualLimitDays is 365
        prefucture = "1"
    else if d.virtualLimit is 1 and d.virtualLimitDays is 180
        prefucture = "2"
    else if d.virtualLimit is 2 and d.virtualLimitDays is 365
        prefucture = "3"
    return  prefucture

  skusCheckboxChange: ->
    b = that.isAllFilled()
    if b is true
      $("#item-push-button").removeAttr("disabled")
    else
      $("#item-push-button").attr("disabled")
    skuList = that.fetchSKUList()
    orderType = $("input[name='goodsType']:checked").val()
    if skuList.length is 0
      $(".skus-table").empty()
      return
    if skuList.length is 1
      entries = skuList[0]
      that.rendorTemplate(0, orderType, entries)
      $(".publish-form").validator()
    else
      entries = that.generateTables(skuList[0], skuList[1])
      that.rendorTemplate(1, orderType, entries)
      $(".publish-form").validator()
    that.setImages()

  rendorTemplate: (single, type, entries)->
    switch single
      when 0
        $(".skus-table").empty().append singleColumnTableTemplate(entries: entries, type: type)
      when 1
        $(".skus-table").empty().append tableTemplate(entries: entries, type: type)

#  setImages: (d)->
#    if d.image1 then images.push(d.image1)
#    if d.image2 then images.push(d.image2)
#    if d.image3 then images.push(d.image3)
#    if d.image4 then images.push(d.image4)
#    if d.image5 then images.push(d.image5)
#    _.each images, (data) ->
#      $(".image-ul").find(".upload-image").remove()
#      $(".image-ul ").append(itemImageTemplate(image: data))
#      if($(".image-ul ").find("li").length < 5)
#        that.setImages()

  selectedImages: (thisTr, d)->
    images = []
    if d.image1 then images.push(d.image1)
    if d.image2 then images.push(d.image2)
    if d.image3 then images.push(d.image3)
    if d.image4 then images.push(d.image4)
    if d.image5 then images.push(d.image5)
    _.each images, (data) ->
      $(thisTr).find(".image-ul").find(".upload-image").remove()
      $(thisTr).find(".image-ul").append(itemImageTemplate(image: data))
      if($(thisTr).find(".image-ul li").length < 5)
        $(thisTr).find(".image-ul").append(itemImageTemplate())


  setImages: ->
    $(".image-ul").append(itemImageTemplate())

  isAllFilled: (type)->
    status = true
    $.each $(".sku-list"), (i, d)->
      if $(@).find(".sku-value:checked").length is 0
        if type
          $(@).find(".sku-value")[0].focus()
        status = false
      return false
    if status is true
      $.each $("input.is-filled"), (i, d)->
        if $(@).val() is ""
          if type
            $(@).focus()
            TipAndAlert.tip $(@).parent(), "error", "up", "请填写此字段"
            $(".tip").css("left", 25).css("top", 36).css("width",85)
          status = false
          return false
    status

  isPrice: ()->
    status = true
    $.each $(".is-price"), (i, d)->
      if  $(@).val() isnt ""
        if !/^(([0-9]*)|(([0]\.\d{1,2}|[1-9][0-9]*\.\d{1,2})))$/.test $(@).val()
          $(@).focus()
          TipAndAlert.tip $(@).parent(), "error", "up", "请输入正确的价格"
          $(".tip").css("left", 25).css("top", 36).css("width",115)
          status = false
          return false
    status

  isNumber:()->
    status = true
    $.each $(".is-number"), (i, d)->
      if  $(@).val() isnt ""
        if !/^[0-9]\d*$/.test $(@).val()
          $(@).focus()
          TipAndAlert.tip $(@).parent(), "error", "up", "只能输入数字"
          $(".tip").css("left", 25).css("top", 36).css("width",100)
          status = false
          return false
    status

  generateTables: (skuList0, skuList1) ->
    entries = []
    if skuList0.length <= skuList1.length
      keys = skuList0
      values = skuList1
    else
      keys = skuList1
      values = skuList0
    _.each keys, (k) ->
      k["values"] = []
      _.each values, (v) ->
        realId = _([k.id, v.id]).sortBy((num) ->
          num
        ).join(",")
        k["values"].push
          realId: realId
          value: v
      entries.push k
    entries

  refillTable: (oldStockValues, oldPriceValues) ->
    $(".skus-table input[name=stock]").each (e) ->
      if oldStockValues[$(e).data("realId")]
        $(e).data "dbId", oldStockValues[$(e).data("realId")].id
        $(e).val oldStockValues[$(e).data("realId")].stock
    $(".skus-table input[name=price]").each (e) ->
      $(e).val oldPriceValues[$(e).data("realId")]

  fetchSKUList: ->
    skuList = []
    $.each $(".skus .sku-property"), ->
      keys = []
      $.each $(this).find("input"), ->
        if $(this).prop("checked")
          key = $(this).parents(".attr").find("label").data("name")
          id = $(this).data("id")
          value = $(this).data("value")
          keys.push
            id: id
            value: value
            key: key
      skuList.push keys  if keys.length isnt 0
    skuList

  selectRecommendGoods: (evt)->
    length = $(".recommend-li").length
    if length >= 3
      that.alert "body", "error", "推荐的礼品最多选择3个！"
      return
    that.recomModal = new Modal(recomTemp({}))
    that.recomModal.show()
    $(".recom-goods-modal").on "click", that.searchRecomBtn, that.searchRecommendGoods
    $(".recom-goods-modal").on "click", that.saveRecomBtn, that.saveRecommendGoods

  searchRecommendGoods: (evt)->
    data = $(".js-recom-val").val()
    if !data
      that.alert "body", "error", "请填写搜索条件！"
      return
    $.ajax
      url: Store.context + "/api/admin/pointsPresent/findRecommendationItemList"
      data:
        searchKey: data
      type: "POST"
      success: (data)->
        $(".pro-select").html(recomSearchResultTemp(data))

  saveRecommendGoods: (evt)->
    itemCode = ""
    data = ""
    $("input[name='recomGoods']").each ->
      if $(@).prop("checked") is true
        itemCode = $(@).val()
        data = $(@).closest("tr").data("data")
    if itemCode is ""
      that.alert "body", "error", "请选择要推荐的礼品！"
      return
    $(".recommend-ul").append(recomResultTemp(data))
    that.recomModal.close()

  delRecommendGoods: (evt)->
    $(@).closest("li").remove()

  presentRegion: ->
    $.get Store.context + "/api/admin/pointsPresent/findAll", (data) ->
      $("#regionType").append(presentRegionTrTemp(data: data.data))
      regionType= $(".js-region-type").data("region-type")
      if regionType
        $("select[name=regionType]").val(regionType)
        $("input[name=pointsType]").val($(".region-type").find("option:selected").data("integ-name"))
        $("input[name=pointsType]").data("id", $(".region-type").find("option:selected").data("integ-id"))
  localOrder: (evt)->
    localOrder = $(@).val()
    if localOrder is "00"
      $(".js-isDisplay-div").hide();
    else if localOrder is "01"
      $(".js-isDisplay-div").show();
    else
      $(".js-isDisplay-div").hide();
    that.skusCheckboxChange()

## 文本域监听,显示可输入的字数
  areaTextListener: (i, self)->
    val = self.val()
    length = parseInt(val.length)
    text = i - length

    if length >= i
      self.val(val.substr(0, i))
      text = 0
    self.next().find("i").text(text)

  setYear: ->
    today = moment()
    nextYear = moment().year(today.year() + 1)
    $(".datepicker").datepicker({
      minDate: new Date(today),
      maxDate: new Date(nextYear),
      yearRange: [today.year(), today.year() + 1]
    })

module.exports = presentAdd