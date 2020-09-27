Modal = require "spirit/components/modal"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"
image = require("extras/image")

recomTemp = App.templates['recommend_goods'] #关联推荐商品模板
recomSearchResultTemp = App.templates['recommend_goods_search_result'] #关联推荐商品查询结果模板
recomResultTemp = App.templates['recommend_goods_result']
spuTemplate = App.templates["item_spu_properties"]
skuTemplate = App.templates["item_sku_properties"]
tableTemplate = App.templates["item_table"]
singleColumnTableTemplate = App.templates["item_single_column_table"]
vendorListTemplate = App.templates["vendor_list"]
itemImageTemplate = App.templates["item_image"]
linkOperateTemplate = App.templates["linkNextOperate"]

class ItemAdd
  _.extend @::, TipAndAlert

  constructor: ->
    text = $('.js-introduction').data('introduction')
    require.async(['/static/umeditor/umeditor.config.js','/static/umeditor/umeditor.min.js'], (a)->
      um = UM.getEditor('editor', {
        zIndex: 99
      });
      um.addListener "ready", ->
        um.setContent(text)
    )

    @$selectRecomBtn = $(".js-recom-select") #关联推荐商品选择按钮
    @searchRecomBtn = ".js-recom-search"
    @delRecomBtn = ".js-recom-del"
    @saveRecomBtn = ".js-recom-sure"
    @addGoodsForm = "form.goods-add-form"
    @$goodsTypeBtn = $(".js-goods-type")
    @vendorSelectBtn = (".js-vendor-select")
    @$uploadBtn = $(".js-upload")
    @$pointRateInput = $(".js-point-rate")
    @spuId = $(".goods-add-form").data("spu-id")
    @vendorId = $(".goods-add-form").data("vendor-id")
    @skusCheckbox = ".skus .sku-value"
    @oldStockValues = {}
    @oldPriceValues = {}
    @imagesUploadButton = $("#replace-image-button")
    @itemAdd = "form.goods-add-form"
    @jsImageUpload = ".js-image-upload"
    @imageReplace = ".image-replace"
    @adWordAreatext = ".js-ad" # 礼品卖点
    @giftDescAreatext = ".js-gift" # 赠品信息
    @delIconBtn = ".js-del-icon"
    @bindEvent()
    #@setYear()
  that = this

  bindEvent: ->
    that = this
    $(document).on "click",@delIconBtn,@delImage
    @$pointRateInput.on "blur", @showOnlyFlag
    $(document).on "click", @delRecomBtn, @delRecommendGoods
    @$selectRecomBtn.on "click", @selectRecommendGoods #点击选择，弹出关联推荐商品弹框
    $(@itemAdd).on "change", @vendorSelectBtn, @showMailStagesAndPeriod #供应商改变时，添加相应的供应商的邮购分期类别码选择列表
    $(document).on "change", @skusCheckbox, @skusCheckboxChange
    $(that.addGoodsForm).validator
      isErrorOnParent: true
    $(that.addGoodsForm).on "submit", @saveGoods
    #@setVendors(@vendorId)
    @setSpus(@spuId)
    @imagesUploadButton.on "click", @imagesUpload
    $(@itemAdd).on "click", @jsImageUpload, @itemImagesUpload
    $(@itemAdd).on "click", @imageReplace, @replaceImage
    @$goodsTypeBtn.on "click", @skusCheckboxChange #订单流程选择O2O商品时，单品表格中添加相应的两列O2O信息
    $(".item-add").on "keydown keyup keypress", @adWordAreatext, ->
      that.areaTextListener(80, $(@))
    $(".item-add").on "blur", @adWordAreatext, ->
      that.areaTextListener(80, $(@))
    $(".item-add").on "keydown keyup keypress", @giftDescAreatext, ->
      that.areaTextListener(100, $(@))
    $(".item-add").on "blur", @giftDescAreatext, ->
      that.areaTextListener(100, $(@))

  imagesUpload: (evt)->
    evt.preventDefault()
    image.selector().done (image_url) ->
      $(".main-image img").attr "src", image_url

  replaceImage: (evt)->
    evt.preventDefault()
    imageList = $(@).closest(".image-replace")
    image.selector().done (image_url) ->
      imageList.find("img").attr "src", image_url

  delImage:->
    imageList = $(@).closest(".image-ul")
    $(@).closest(".item-image-li").remove()
    if $(".js-image-upload").length < 1 and imageList.find("li").length < 5
      imageList.append(itemImageTemplate())

  itemImagesUpload: (evt)->
    evt.preventDefault()
    imageList = $(@).closest(".image-ul")
    image.selector().done (image_url) ->
      imageList.find(".upload-image").remove()
      imageList.append(itemImageTemplate(image: image_url))
      if(imageList.find("li").length < 5)
        imageList.append(itemImageTemplate())


  setImages: ->
    $(".image-ul").append(itemImageTemplate())

  setVendors: (vendorId)->
    if vendorId
      $.get Store.context + "/api/admin/cooperation/#{vendorId}", (data) ->
        $(".js-vendor-list").append(vendorListTemplate(data: data.data.result, type: 2))
    else
      $.get Store.context + "/api/admin/cooperation/list?channel=YG", (data)->
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
    goodsCode = $("input[name=code]").val()
    approveStatus = $("form.goods-add-form").data("approve-status") + ""
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
        $(thisTr).find("input[name=stock]").val(d.stock)
        $(thisTr).find("input[name=o2oCode]").val(d.o2oCode)
        $(thisTr).find("input[name=voucher]").val(d.o2oVoucherCode)
        $(thisTr).find("input[name=price]").val(d.price)
        $(thisTr).find("input[name=marketPrice]").val(d.marketPrice)
        $(thisTr).find("input[name=fixPoint]").val(d.fixPoint)
        #管理平台不允许为供应商修改价格
        $(thisTr).find("input[name=marketPrice]").attr("readonly", true)
        $(thisTr).find("input[name=price]").attr("readonly", true)
        $(thisTr).find("input[name=fixPoint]").attr("readonly", true)
        $(thisTr).find("input[name=stagesCode]").val(d.stagesCode)
        $(thisTr).find("input[name=stockWarning]").val(d.stockWarning)
        $(thisTr).find("select[name=wxLimitCount]").val(d.wxLimitCount)
        $("input[name=productPointRate]").val(d.productPointRate)
        if d.productPointRate is 1
          $("input[name=displayFlag]").show()
        stagesCodes = $(".js-mail-stages").data("mail-stages")
        html =""
        periodHtml = ""
        _.each stagesCodes, (d) ->
          html += '<option value="' + d.code + '">' + d.code + '</option>'
        $(thisTr).find("select[name=stagesCode]").append(html)
        $(thisTr).find("select[name=stagesCode]").val(d.stagesCode)
        installmentNumber = d.installmentNumber
        periods = $(".skus").data("periods")
        _.each periods, (v)->
          periodHtml += "<input value=" + v.period + " name='period' type='checkbox' />" + v.period
        $(thisTr).find(".js-period-td").append(periodHtml)
        if installmentNumber
          _.each installmentNumber.split(","), (data) ->
            $(thisTr).find("input[name=period][value=#{data}]").prop "checked", true
        that.selectedImages(thisTr, d)
    else
      that.skusCheckboxChange()

  skusCheckboxChange: ->
    b = that.isAllFilled()
    if b is true
      $("#item-push-button").removeAttr("disabled")
    else
      $("#item-push-button").attr("disabled")
    $(".skus-table input[name=stock]").each (d)->
      if that.oldStockValues[$(@).data("real-id")]
        that.oldStockValues[$(@).data("real-id")].stock = $(@).val()
      else
        that.oldStockValues[$(@).data("real-id")] =
          id: null
          stock: $(@).val()
    $(".skus-table input[name=price]").each (d) ->
      that.oldPriceValues[$(@).data("realId")] = $(@).val()

    skuList = that.fetchSKUList()
    goodsType = $("input[name='goodsType']:checked").val()
    if skuList.length is 0
      $(".skus-table").empty()
      return
    if skuList.length is 1
      that.rendorTemplate(0, goodsType, skuList[0])
      $(".publish-form").validator()
    else
      entries = that.generateTables(skuList[0], skuList[1])
      that.rendorTemplate(1, goodsType, entries)
      $(".publish-form").validator()
    that.setImages()
    code = $("input[name='code']").val()
    if !code
      that.showMailStagesAndPeriod()

  rendorTemplate: (single, type, entries)->
    switch single
      when 0
        $(".skus-table").empty().append singleColumnTableTemplate(entries: entries, type: type)
      when 1
        $(".skus-table").empty().append tableTemplate(entries: entries, type: type)

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
            TipAndAlert.tip $(@).parent(),"error","up","请填写此字段"
            $(".tip").css("left", 25).css("top", 36).css("width",100)
          status = false
          return false
    status
  isPrice: ()->
    status = true
    $.each $(".is-price"), (i, d)->
      if $(@).val() isnt ""
        if !/^(([1-9][0-9]*)|(([0]\.\d{1,2}|[1-9][0-9]*\.\d{1,2})))$/.test $(@).val()
          TipAndAlert.tip $(@).parent(),"error","up","请填写正确价格"
          $(".tip").css("left", 25).css("top", 36).css("width",120)
          $(@).focus()
          status = false
          return false
    status

  isNumber:()->
    status = true
    $.each $(".is-number"), (i, d)->
      if $(@).val() isnt ""
        if !/^[0-9]\d*$/.test $(@).val()
          TipAndAlert.tip $(@).parent(),"error","up","请填写正确数字"
          $(".tip").css("left", 25).css("top", 36).css("width",120)
          $(@).focus()
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

  showOnlyFlag: (evt)->
    rate = $(".js-point-rate").val()
    $(".js-display-flag").css('display', 'none')
    if rate isnt ""
      if  !/^([01](\.0+)?|0\.[0-9]+)$/.test rate
        that.alert "body", "error", "积分支付比例输入不符合规则！"
        return
      if Number(rate) is 1
        $(".js-display-flag").css('display', 'block')

#供应商可选择的商品类型
#合作商角色（乐购合作商权限位 0: VMI合作商,1: VMI物流商,2: 高级合作商,3:020合作商）',
  vendorGoodsType: (vendorRole)->
    if vendorRole is 2
      $(".goods-type-entity").removeAttr("disabled")
      $(".goods-type-entity").prop "checked", true
    else if vendorRole is 3
      $(".goods-type-o2o").removeAttr("disabled")
      $(".goods-type-o2o").prop "checked", true
    else
      $(".goods-type-entity").removeAttr("disabled")
      $(".goods-type-o2o").removeAttr("disabled")

  showMailStagesAndPeriod: ->
    vendorId = $(".goods-add-form").data("vendor-id")
    if !vendorId
      vendorId = $(".js-vendor-select").val()
    if vendorId is ""
      return
    code = $("input[name=code]").val()
    $.ajax
      url: Store.context + "/api/admin/goods/add-findMailStagesAndPeriod"
      type: "POST"
      data: {vendorId: vendorId}
      success: (data)->
        if !data.data.mailStagesModelList
          that.alert "body", "error", "该供应商未填写邮购分期类别码！"
          return
        if !data.data.periodList
          that.alert "body", "error", "该供应商未填写分期信息！"
          return
        mailHtml = ""
        periodHtml = ""
        _.each data.data.mailStagesModelList, (item) ->
          mailHtml += "<option value=" + item.code + ">" + item.code + "</option>"
        if $(".js-mail-stages").val() is ""
          $(".js-mail-stages").html('<option  value="">请选择</option>').append(mailHtml)
        $(".js-mail-select").html('<option  value="">请选择</option>').append(mailHtml)
        _.each data.data.periodList, (item)->
          periodHtml += "<input value=" + item + " name='period' type='checkbox' checked/>" + item
        $(".js-period-td").html(periodHtml)

        mailOrderCode = $(".js-mail-stages").data("mailordercode")
        if mailOrderCode
          $(".js-mail-stages").val(mailOrderCode)

      complete: ->


  selectRecommendGoods: (evt)->
    length = $(".recommend-li").length
    if length >= 3
      that.alert "body", "error", "推荐的商品最多选择3个！"
      return
    that.recomModal = new Modal(recomTemp({}))
    that.recomModal.show()
    $(".recom-goods-modal").on "click", that.searchRecomBtn, that.searchRecommendGoods
    $(".recom-goods-modal").on "click", that.saveRecomBtn, that.saveRecommendGoods

  searchRecommendGoods: (evt)->
    data = $(".js-recom-val").val()
    if data is "" or undefined
      that.tip $(".js-recom-val").parent(), "error", "up", "请填写搜索条件！"
      $(".tip").css("left", 137).css("top", 35)
      return
    $.ajax
      url: Store.context + "/api/admin/goods/add-findRecommendationItemList"
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
      that.alert "body", "error", "请选择要推荐的商品！"
      return
    $(".recommend-ul").append(recomResultTemp(data))
    that.recomModal.close()

  delRecommendGoods: (evt)->
    $(@).closest("li").remove()

  checkTime: (autoOffShelfTime)->
    time = new Date(autoOffShelfTime.replace(/-/g,"/"))
    now = new Date
    return now < time


  saveGoods: (evt) ->
    evt.preventDefault()
    $(that.addGoodsForm).validator
      isErrorOnParent: true

    recommendGoodsCodes = []
    #关联推荐商品
    if $(".recommend-li").length isnt 0
      $(".recommend-li").each ->
        recommendGoodsCodes.push $(@).data("code")

    #服务承诺字段
    servicePromise = [];
    $("input[name='servicePromise']:checkbox").each ->
      if($(@).prop("checked"))
        servicePromise.push $(@).val()
    @services = ""
    if servicePromise.length > 0
      @services = servicePromise.join(",")
    vendorId = $("input[name=vendorId]").val()
    if !vendorId
      vendorId = $("select[name=vendorId]").val() #供应商id
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
    if !that.checkTime($("input[name=autoDownShelfDate]").val())
      that.alert "body", "error", "自动下架时间不能小于当前日期！"
      return
    data = goods:
      code: $("input[name=code]").val()
      productId: that.spuId #产品Id
      vendorId: vendorId
      name: $("input[name=goodsName]").val()#商品名
      manufacturer: $("input[name=manufacturer]").val()  #厂家
      goodsType: $("input[name=goodsType]:checked").val()  # 商品类型
      isInner: $("input[name=isInner]:checked").val()  #是否内宣
      autoOffShelfTime: $("input[name=autoDownShelfDate]").val() #自动下架时间
      cards: $("input[name=cards]").val() #卡
      mailOrderCode: $("select[name=mailOrderCode]").val()
      adWord: $("textarea[name=adWord]").val()#卖点
      giftDesc: $("textarea[name=giftDesc]").val()#赠品
      introduction: UM.getEditor('editor').getContent()#获取富文本编辑器内容
      serviceType: @services
      displayFlag: $("input[name=displayFlag]").isChecked

    skuList = that.fetchSKUList()
    if skuList.length is 0
      that.alert "body", "error", "请至少添加一条销售属性！"
      return
    list = []
    periodFlag=true
    imageFlag=true
    if skuList.length is 1
      _.each $(".skus-table tbody tr"), (tr) ->
        columnKey = $(".skus-table thead th:first").text()
        columnId = $("td.column", tr).data("id")
        columnName = $("td.column", tr).data("name")
        marketPrice = $("td input[name=marketPrice]", tr).val()
        price = $("td input[name=price]", tr).val()
        stock = $("td input[name=stock]", tr).val()
        fixPoint = $("td input[name=fixPoint]", tr).val()
        stagesCode = $("td select[name=stagesCode]").val()
        code = $("td input[name=stock]", tr).data("db-id")
        stockWarning = $("td input[name=stockWarning]", tr).val()
        o2oCode = $("td input[name=o2oCode]", tr).val()
        o2oVoucherCode = $("td input[name=voucher]", tr).val()
        perids = []
        _.each $("td input[name=period]:checked", tr), (data) ->
          perids.push($(data).val())
        installmentNumber = perids.join(",")
        if installmentNumber is ""
          periodFlag=false
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
        list.push
          code: code
          attributeKey1: columnKey
          attributeName1: columnName
          attributeValue1: columnId
          marketPrice: marketPrice
          price: price
          fixPoint: fixPoint
          stagesCode: stagesCode
          stockWarning: stockWarning
          stock: stock
          installmentNumber: installmentNumber
          o2oCode:o2oCode
          o2oVoucherCode:o2oVoucherCode
          cardLevelId:'00'
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
        marketPrice = $("td input[name=marketPrice]", tr).val()
        price = $("td input[name=price]", tr).val()
        stock = $("td input[name=stock]", tr).val()
        fixPoint = $("td input[name=fixPoint]", tr).val()
        stagesCode = $("td select[name=stagesCode]").val()
        code = $("td input[name=stock]", tr).data("db-id")
        stockWarning = $("td input[name=stockWarning]", tr).val()
        o2oCode = $("td input[name=o2oCode]", tr).val()
        o2oVoucherCode = $("td input[name=voucher]", tr).val()
        perids = []
        _.each $("td input[name=period]:checked", tr), (data) ->
          perids.push($(data).val())
        installmentNumber = perids.join(",")
        if installmentNumber is ""
          periodFlag = false
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
        list.push
          code: code
          attributeKey1: mainColumnKey
          attributeName1: mainColumnName
          attributeValue1: mainColumnId
          attributeKey2: columnKey
          attributeName2: columnName
          attributeValue2: columnId
          marketPrice: marketPrice
          price: price
          fixPoint: fixPoint
          stagesCode: stagesCode
          stockWarning: stockWarning
          stock: stock
          installmentNumber: installmentNumber
          o2oCode:o2oCode
          o2oVoucherCode:o2oVoucherCode
          cardLevelId:'00'
          image1: image1
          image2: image2
          image3: image3
          image4: image4
          image5: image5
    if periodFlag is false
      that.alert "body","error", "请为每条单品选择期数！"
      return
    if imageFlag is false
      that.alert "body","error", "请为每条单品上传图片！"
      return
    data.displayFlag = 0
    productPointRate = $("input[name='productPointRate']").val()
    if productPointRate
      data.productPointRateParam = productPointRate
      if Number(productPointRate) is 1 and $("input[name='displayFlag']").is(':checked')
        data.displayFlag = 1
    data.itemList = list
    data.recommendGoodsCodes=recommendGoodsCodes.join(",")
    b = that.isAllFilled(1)
    if !b
      return
    type = $('input[name="addType"]').val()
    isNumFlag=that.isNumber()
    if isNumFlag is false
       return;
    isPriceFlag=that.isPrice()
    if isPriceFlag is false
       return
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
          channel: "YG"
        success: (data) ->
          $("body").spin(false)
          new Modal(linkOperateTemplate({title: "发布成功", content: "发布商品已经成功，您可以去选择接下来的操作"})).show()
        complete: ->
          $("body").spin(false)
# window.location.href = Store.context + "/mall/item/all-goods"

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
  setYear: ->
    today = moment()
    nextYear = moment().year(today.year() + 1)
    $(".datepicker").datepicker({
      minDate: new Date(today),
      maxDate: new Date(nextYear),
      yearRange: [today.year(), today.year() + 1]
    })

## 文本域监听,显示可输入的字数
  areaTextListener: (i, self)->
    val = self.val()
    length = parseInt(val.length)
    text = i - length

    if length >= i
      self.val(val.substr(0, i))
      text = 0
    self.next().find("i").text(text)

module.exports = ItemAdd