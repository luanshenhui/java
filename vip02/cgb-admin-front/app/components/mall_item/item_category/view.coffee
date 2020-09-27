Store = require "extras/store"
TipAndAlert = require "tip_and_alert/tip_and_alert"

class releaseItemsCategory
  _.extend @::, TipAndAlert
  sort =
    "backCategory":
      "type": -1
      "maxLength": 4
      "url": Store.context + "/api/admin/backCategories"
    "frontCategory":
      "type": 1
      "maxLength": 3
      "url": Store.context + "/api/admin/frontCategories"

  constructor: ->
    @$submitSpu = $(".js-submit-spu")
    @nextLever = "li.divide-li"
    @categorySearch = (".js-search-item")
    @categoryType = sort[$(".category").data("type")]
    @$jsDownloadXlBtn = $(".js-download-xl")
    @$jsAddToListBtn = $(".js-add-to-list")
    @spuRemoveBtn = ".js-spu-remove"
    @bindEvent()
  that = this
  spuLi = App.templates['download_spu']

  bindEvent: ->
    that = this
    @$submitSpu.on "click", @submitSpuClick
    $(".fixed-category").on("click", @nextLever, @nextCategory)
    $(".fixed-category").on("keyup", @categorySearch, @categorySearchItem)
    @$jsDownloadXlBtn.on "click", @downloadXls
    @$jsAddToListBtn.on "click",@addToList
    $(document).on "click", @spuRemoveBtn, @removeSpuLi

  addToList:->
    $(".js-spu-table").css("display","block")
    if $(".js-spu-selected").length>=50
      that.alert "body", "error", "最多只能选择50个产品！"
      return
    spu= $(".spu-ul .selected").data("category")
    exit = true
    $(".js-spu-selected").each ->
      if Number($(@).data("id")) is Number(spu.id)
        exit = false
    if exit is false
      that.alert "body", "error", "该产品已存在！"
      return
    $(".js-spu-table").find("tbody").append(spuLi(spu))

  removeSpuLi:->
    $(@).closest("tr").remove()

  downloadXls: ->
    spuIdList=[]
    $(".js-spu-selected").each ->
      spuIdList.push($(@).data("id"))
    if spuIdList.length<=0
      that.alert "body", "error", "请先选择产品再进行模板下载！"
      return
    spuIds = spuIdList.join(",")
    channel = $("input[name='channel']").val()
    location.href = Store.context + "/api/admin/goods/import-exportTemplateExcel?spuIds=#{spuIds}&channel=#{channel}"

  submitSpuClick: ->
    if $(".category-spu .selected").length > 0
      spuId = $(".category-spu .selected").data("category").id
      spuPath = $(".selected-path").html()
      if $("input[name=channel]").val() is "JF"
         window.location.href = Store.context + "/points/item/add-present?spuId=#{spuId}&spuPath=#{spuPath}"
      else
         window.location.href = Store.context + "/mall/item/add-goods?spuId=#{spuId}&spuPath=#{spuPath}"

  categorySearchItem: ->
    if($(this).val())
      $(@).closest(".category-body").find(".divide-ul li").hide().filter(":contains('" + ( $(this).val() ) + "')").show()
    else
      $(@).closest(".category-body").find(".divide-ul li").show()

  nextCategory: ->
    $(this).parents(".category").nextAll().remove()
    categoryData = $(@).data("category")
    $(@).addClass("selected")
    $(@).siblings().removeClass("selected")
    $(".js-submit-spu").attr("disabled", true)
    $(".js-download-xl").attr("disabled", true)
    $(".js-add-to-list").attr("disabled", true)
    $(".category-list").spin("medium")
    $(@).removeClass("mouseover")
    if categoryData.hasChild is true
      $.ajax
        url: Store.context + "/api/admin/backCategories/#{categoryData.id}/children"
        type: "GET"
        success: (data) ->
          categoryTemplate = App.templates["category_spu"]({extras: {"level": parseInt(categoryData.level) + 1, "parentId": categoryData.id}, data: data})
          $(".fixed-category").append(categoryTemplate)
          $(".category-list").spin(false)
        complete: ->
          $(".category-list").spin(false)
    else
      if categoryData.level <= that.categoryType.maxLength
        that.renderSpus(categoryData)
      else
        $(".category-list").spin(false)
        that.setSpu(categoryData)

  renderSpus: (categoryData)->
    $.ajax
      url: Store.context + "/api/admin/backCategories/#{categoryData.id}/spus"
      type: "GET"
      success: (data) ->
        spuTemplate = App.templates["category_spu"]({extras: {"level": 5, "parentId": categoryData.id}, data: data})
        $(".fixed-category").append(spuTemplate)
        $(".category-#{that.categoryType.maxLength + 1}").addClass("category-spu")

      complete: ->
        $(".category-list").spin(false)

  setSpu: (categoryData)->
    $(".js-submit-spu").attr("disabled", false)
    $(".js-download-xl").attr("disabled", false)
    $(".js-add-to-list").attr("disabled", false)
    selectedItemsCache = []
    $.each $(".selected"), (i, d)->
      selectedItemsCache[i] = $(@).data("category").name
    selectedString = selectedItemsCache.join("-")
    $(".selected-path").html(selectedString)

module.exports = releaseItemsCategory
