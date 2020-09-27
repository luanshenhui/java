Modal = require "spirit/components/modal"
spuTemplate = App.templates.spu_detail.templates["spu_properties"]
skuTemplate = App.templates.spu_detail.templates["sku_properties"]
singleColumnTableTemplate = App.templates.spu_detail.templates["single_column_table"]
tableTemplate = App.templates.spu_detail.templates["table"]
Store = require "extras/store"
class ReleaseItems

  constructor: ->
    @spuId = $(".publish-form").data("spu-id")
    @imagesSelect = $(".images li")
    @imagesASelect = $(".images li a")
    @imagesUploadButton = $("#replace-image-button")
    @skusCheckbox = ".skus .sku-value"
    @publishItemButton = $("#publish-item-button")
    @publishForm = $(".publish-form")
    @oldOuterIdValues = {}
    @oldModelValues = {}
    @bindEvent()

  that = this

  bindEvent: ->
    that = this
    @setSpus(@spuId)
    $(".form-aligned").validator()
    @imagesSelect.on "click", @imagesClick
    @imagesASelect.on "click", @imagesDelete
    @imagesUploadButton.on "click", @imagesUpload
    @publishForm.on "submit", @publishItemSubmit

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
  refillTable: (oldOuterIdValues, oldModelValues) ->
    $(".skus-table input[name=outerId]").each (e) ->
      if oldOuterIdValues[$(e).data("realId")]
        $(e).data "dbId", oldOuterIdValues[$(e).data("realId")].id
        $(e).val oldOuterIdValues[$(e).data("realId")].outerId
    $(".skus-table input[name=model]").each (e) ->
      $(e).val oldModelValues[$(e).data("realId")]
  setSpus: (spuId)->
    $.get Store.context + "/api/admin/spus/#{spuId}/defaultItem", (data)->
      that.setSku(data)
    $.get Store.context + "/api/admin/spus/#{spuId}", (data)->
      $(".selected-path").text(data.data.spu.name)
  skusCheckboxChange: ()->
    $("#publish-item-button").removeAttr("disabled")
    $(".skus-table input[name=outerId]").each (d)->
      if that.oldOuterIdValues[$(@).data("real-id")]
        that.oldOuterIdValues[$(@).data("real-id")].outerId = $(@).val()
      else
        that.oldOuterIdValues[$(@).data("real-id")] =
          id: null
          outerId: $(@).val()
    $(".skus-table input[name=model]").each (d) ->
      that.oldModelValues[$(@).data("realId")] = $(@).val()
    skuList = that.fetchSKUList()
    if skuList.length is 0
      $(".skus-table").empty()
      return
    if skuList.length is 1
      $(".skus-table").empty().append singleColumnTableTemplate(entries: skuList[0])
      that.refillTable that.oldOuterIdValues, that.oldModelValues
      $(".publish-form").validator()
    else
      entries = that.generateTables(skuList[0], skuList[1])
      $(".skus-table").empty().append tableTemplate(entries: entries)
      that.refillTable that.oldOuterIdValues, that.oldModelValues
      $(".publish-form").validator()

  setSku: (data)->
    $(".skus").append(skuTemplate({data: data.data}))
    selectedSkus = $(".mall-item-publish .control-group .skus").data("skus")
    if selectedSkus isnt null
      that.skusCheckboxChange()
      $.each selectedSkus, (i, d)->
        thisTr = $(".skus-table tbody").find("tr")[i]
        $(thisTr).find("input[name=outerId]").attr("data-db-id", d.id)
        $(thisTr).find("input[name=outerId]").val(d.outerId)
        $(thisTr).find("input[name=model]").val(d.model)
        if d.price is undefined
          $(thisTr).find("input[name=skuPrice]").val("")
        else
          $(thisTr).find("input[name=skuPrice]").val(d.price / 100)
    else
      that.skusCheckboxChange()

  imagesClick: ->
    if $(@).find(".thumbnail").attr("src") isnt ""
      $("#replace-image-button").html("替换图片")
    else
      $("#replace-image-button").html("上传图片")
    $(@).addClass "selected"
    $("a", @).removeClass "hide"
    $(@).siblings().removeClass "selected"
    $(@).siblings().find("a").addClass "hide"
    $(".main-image img").attr "src", $("img", @).attr("src")

  imagesUpload: (evt)->
    image = require("extras/image")
    evt.preventDefault()
    image.selector().done (image_url) ->
      $(".images .selected img").attr "src", image_url
      $(".main-image img").attr "src", image_url
      $("#replace-image-button").html("替换图片")

  imagesDelete: ->
    $("#replace-image-button").html("上传图片")
    $image = $(@).siblings()
    $image.attr("src", "")
    $(".main-image img").removeAttr("src")

  inputKeyup: ->
    if $(@).val() isnt ""
      $("#publish-item-button").removeAttr("disabled")
    else
      $("#publish-item-button").attr("disabled", true)

  getDefaultItem: ->
    name = $("input[name=name]").val()
    price = $("input[name=price]").val() * 100
    mainImage = $("#itemMainImage").attr "src"
    image1 = $("#itemImage1").attr "src"
    image2 = $("#itemImage2").attr "src"
    image3 = $("#itemImage3").attr "src"
    image4 = $("#itemImage4").attr "src"
    defaultItem =
      name: name
      price: price
      mainImage: mainImage
      image1: image1
      image2: image2
      image3: image3
      image4: image4

  getSkuList: ->
    skuList = that.fetchSKUList()
    list = []
    if skuList.length is 1
      _.each $(".skus-table tbody tr"), (tr) ->
        columnKey = $(".skus-table thead th:first").text()
        columnId = $("td.column", tr).data("id")
        columnName = $("td.column", tr).data("name")
        defaultModel = $("td input[name=model]", tr).val()
        outerId = $("td input[name=outerId]", tr).val()
        dbId = $("td input[name=outerId]", tr).data("dbId")
        if $("td input[name=skuPrice]", tr).val() isnt ""
          price = ($("td input[name=skuPrice]", tr).val() * 100).toFixed()
        else
          price = $("td input[name=skuPrice]", tr).val()
        if defaultModel is ""
          defaultmodel = ""
        else
          defaultmodel = defaultModel
        if dbId is undefined
          dbId = ""
        list.push
          id: dbId
          attributeKey1: columnKey
          attributeName1: columnName
          attributeValue1: columnId
          model: defaultModel
          outerId: outerId
          price: price
    else
      @mainColumnKey = undefined
      @mainColumnName = undefined
      @mainColumnId = undefined
      _.each $(".skus-table tbody tr"), (tr) ->
        if $("td.main-column", tr).attr("rowspan")
          @mainColumnKey = $(".skus-table thead th:first").text()
          @mainColumnName = $("td.main-column", tr).data("name")
          @mainColumnId = $("td.main-column", tr).data("id")
        columnKey = $(".skus-table thead th:nth-child(2)").text()
        columnId = $("td.column", tr).data("id")
        columnName = $("td.column", tr).data("name")
        defaultModel = $("td input[name=model]", tr).val()
        outerId = $("td input[name=outerId]", tr).val()
        dbId = $("td input[name=outerId]", tr).data("dbId")
        if $("td input[name=skuPrice]", tr).val() isnt ""
          price = ($("td input[name=skuPrice]", tr).val() * 100).toFixed()
        else
          price = $("td input[name=skuPrice]", tr).val()
        if defaultModel is ""
          defaultmodel = ""
        else
          defaultmodel = defaultmodel
        if dbId is undefined
          dbId = ""
        list.push
          id: dbId
          attributeKey1: @mainColumnKey
          attributeName1: @mainColumnName
          attributeValue1: @mainColumnId
          attributeKey2: columnKey
          attributeName2: columnName
          attributeValue2: columnId
          model: defaultModel
          outerId: outerId
          price: price
    list

  publishItemSubmit: (evt)->
    evt.preventDefault()
    skus = that.getSkuList()
    defaultItem = that.getDefaultItem()
    $("body").spin("large")
    item = defaultItem: defaultItem
    item.skus = skus
    if $(".mall-item-publish .spu-title").data("isupdate")
      spuId = $(".publish-form").data("spu-id")
      $.ajax(
        type: "PUT"
        url: Store.context + "/api/admin/spus/#{spuId}/defaultItem"
        contentType: "application/json"
        data: JSON.stringify(item)
      ).done ->
        $("body").spin(false)
        new Modal(
          "icon": "success"
          "title": "产品修改成功！"
          "content": "产品修改成功, 确认后将关闭此页面"
        ).show()
        $(".close").on "click", ->
          window.close()
    else
      spuId = $(".publish-form").data("spu-id")
      $.ajax
        type: "POST"
        url: Store.context + "/api/admin/spus/#{spuId}/defaultItem"
        contentType: "application/json"
        data: JSON.stringify(item)
      .done ->
        $("body").spin(false)
        new Modal(
          "icon": "success"
          "title": "产品保存成功！"
          "content": "产品保存成功, 确认后将关闭此页面"
        ).show()
        $(".close").on "click", ->
          window.close()

module.exports = ReleaseItems
