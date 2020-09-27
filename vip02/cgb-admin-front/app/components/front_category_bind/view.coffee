Modal = require "spirit/components/modal"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"

class categoryBind
  _.extend @::, TipAndAlert
  constructor: ->
    @$bindButtonSelect = $(".js-front-category-bind")
    @$removeButtonSelect = $(".js-front-category-delete")
    @$reBindButtonSelect = $(".js-front-category-rebind")
    @bindEvent()
  that = this

  bindEvent: ->
    that = this
    @$bindButtonSelect.on("click", @frontCategoryBind)
    $(document).on "confirm:delete-bind", that.frontCategoryDelete
    @$reBindButtonSelect.on("click", @frontCategoryBind)

  BindRequst: (frontCategoryData, bindString)->
    frontCategoriesId = frontCategoryData.id
    frontCategoriesLevel = frontCategoryData.level
    $.ajax
      url: Store.context + "/api/admin/frontCategories/mapping"
      data: bindString
      type: "POST"
      success: ->
        $(".front-category-bind").remove()
        $.get Store.context + "/api/admin/frontCategories/#{frontCategoriesId}/mapping", (data)->
          if _.isEmpty data.data
            json = {"data": "", "frontCategoryData": frontCategoryData}
          else
            json = {"data": data, "frontCategoryData": frontCategoryData}
          categoryBind = App.templates["front_category_bind"]
          if frontCategoriesLevel < 3
            $(".category-#{frontCategoriesLevel}").nextAll(".category").remove()
          $(".front-area").remove()
          $(".edit-area").append("""<div class="front-area"></div>""")
          $(".front-area").append(categoryBind({"data": json}))
          bindComponent = require("front_category_bind/view")
          $(document).unbind "confirm:delete-bind"
          new bindComponent()
          $(".category-#{frontCategoriesLevel} .selected .js-delete-category").hide()

  frontCategoryBind: ->
    stringCache = []
    frontCategoryData = $(".front-category-bind").data("frontid")
    frontCategoriesId = frontCategoryData.id
    frontCategoriesLevel = frontCategoryData.level
    channel = $(".js-front-category-bind").data("channel")
    $.get Store.context + "/api/admin/backCategories?channel=" + channel, (data) ->
      popCategory = App.templates["popup_bind"]
      new Modal(popCategory({
        extras: {
          "level": 1,
          "parentId": 0
        }, data: data
      })).show()
      $(".js-bind-front-category").on "click", ->
        selectString = ""
        backCategoriesId = ""
        backCategoriesItem = []
        selectedItem = $(".pop-main").find(".selected")
        backCategoriesSelect = $(".pop-main .selected")
        length = $(".pop-main .selected").length
        $.each backCategoriesSelect, (i, d)->
          backCategoriesItem[i] = $(@).data("category")
        if _.isEmpty backCategoriesItem
          that.alert ".bind-category-pop", "info", "小贴士", "请选择叶子类目"
          $(".alert").css("top", 160).css("left", 300)
        else
          if backCategoriesItem[length - 1].hasChild
            that.alert ".bind-category-pop", "info", "小贴士", "请选择叶子类目"
            $(".alert").css("top", 160).css("left", 300)
          else
            backCategoriesId = backCategoriesItem[length - 1].id
            $.each selectedItem, (i, d)->
              stringCache[i] = $(@).find(".item-pop span").html()
            selectString = encodeURIComponent(stringCache.join(" > "))
            bindString = "fid=" + frontCategoriesId + "&bid=" + backCategoriesId + "&path=" + selectString
            that.BindRequst(frontCategoryData, bindString)
            $(".modal-footer .close").trigger("click")
            $(".modal").remove()
      Component = require($(".popup-bind.js-component").data("comp-path"))
      new Component("backCategories")

  frontCategoryDelete: (evt, data)->
    frontCategoryData = $(".front-category-bind").data("frontid")
    frontCategoriesId = frontCategoryData.id
    frontCategoriesLevel = frontCategoryData.level
    thisLine = $("##{data}").closest(".binded-line")
    bindData = thisLine.data("bind")
    data = {fid: bindData.frontCategoryId, bid: bindData.backCategoryId, path: bindData.path}
    $.ajax
      url: Store.context + "/api/admin/frontCategories/mapping/remove"
      type: "POST"
      data: data
      async: false
      success: ->
        $(".front-category-bind").remove()
        $.get Store.context + "/api/admin/frontCategories/#{frontCategoriesId}/mapping", (data)->
          if _.isEmpty data.data
            json = {"data": "", "frontCategoryData": frontCategoryData}
          else
            json = {"data": data, "frontCategoryData": frontCategoryData}
          categoryBind = App.templates["front_category_bind"]
          if frontCategoriesLevel < 3
            $(".category-#{frontCategoriesLevel}").nextAll(".category").remove()
          $(".front-area").remove()
          $(".edit-area").append("""<div class="front-area"></div>""")
          $(".front-area").append(categoryBind({"data": json}))
          bindComponent = require("front_category_bind/view")
          $(document).unbind "confirm:delete-bind"
          new bindComponent()
          $(".category-#{frontCategoriesLevel} .selected .js-delete-category").hide()
module.exports = categoryBind
