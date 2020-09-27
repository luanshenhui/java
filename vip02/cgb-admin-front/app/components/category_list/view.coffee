Modal = require "spirit/components/modal"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"
image = require("extras/image")

spuManageTemplate = App.templates["spu_manage"]
attributeManageTemplate = App.templates["attributes_manage"]
categoryItemTemplate = App.templates["_category_item"]
categoryTemplate = App.templates["category"]
categoryBind = App.templates["front_category_bind"]

class backCategories
  _.extend @::, TipAndAlert
  manageComp = null
  bind = null
  sort =
    "backCategory":
      "type": -1
      "maxLength": 3
      "url": Store.context + "/api/admin/backCategories"
    "frontCategory":
      "type": 1
      "maxLength": 3
      "url": Store.context + "/api/admin/frontCategories"

  constructor: ->
    @nextLevel = ("li.divide-li")
    @categoryAdd = (".js-add-category")
    @categoryUpdate = (".js-update-category")
    @categoryDelete = (".js-delete-category")
    @categoryEdit = (".js-edit-category")
    @categorySearch = (".js-search-item")
    @categoryEditForm = (".category-edit-form")
    @categoryType = sort[$(".category").data("type")]
    @imageUpload = ".image-upload"
    #setHeight()

    @bindEvent()
  that = this
  bindEvent: ->
    that = this
    $(".category-container").on "click", @nextLevel, @nextCategory
    $(".category-container").on "click", @categoryAdd, @addCategory
    $(".category-container").on "click", @categoryUpdate, @updateCategory
    $(".category-container").on "click", @categoryEdit, @editCategory
    $(".category-container").on "keyup", @categorySearch, @categorySearchItem
    $(document).on "click", @stopEdit
    $(".category-container").on "click", @categoryEditForm, @categoryEditFormClick
    $(".category-container").on "click", @imageUpload, @uploadImage
    $(document).on "confirm:delete-category",@deleteCategoryConfirm

  uploadImage: (evt)->
    evt.preventDefault()
    imageList = $(@)
    categoryId = $(@).closest(".divide-li").attr "id"
    image.selector().done (image_url) ->
      imageList.find("i").remove()
      imageList.find("img").remove()
      url = image_url
      imageList.append('<img src="' + url + '" height="15px" width="15px" title="图标">')
      $.ajax
        url: "#{that.categoryType.url}/icon/#{categoryId}"
        type: "POST"
        data: {url: url}
        success: =>
          that.alert ".main", "success", "上传成功！", "前台类目图标上传成功！"
          $(".alert").css("top", 200).css("left", 600)

  setHeight = ->
    @height = $(".sidebar").height()
    @headerHeight = $(".category-container .category .category-header").height()
    @listHeight = $(".category-container").height()
    @devideHeight = @listHeight - @headerHeight
    $(".edit-area").css("height", @listHeight - 35)
    $(".category-container .category").css("height", @listHeight)
    $(".category-container .category .category-body").css("height", @devideHeight)
    $(".category-container .divide-ul").css("height", @devideHeight)

  $(".js-sync-front").on "click", ->
    $(".main").spin("big")
    $.ajax
      url: Store.context + "/api/admin/forest/frontSync"
      type: "POST"
      success: (data)->
        that.alert ".main", "success", "同步成功！", "前台同步成功！"
        $(".alert").css("top", 200).css("left", 600)
      complete: ->
        $(".main").spin(false)

  $(".js-sync-back").on "click", ->
    $(".main").spin("big")
    $.ajax
      url: Store.context + "/api/admin/forest/backSync"
      type: "POST"
      success: (data)->
        that.alert ".main", "success", "同步成功！", "后台同步成功！"
        $(".alert").css("top", 200).css("left", 600)
      complete: ->
        $(".main").spin(false)

  categorySearchItem: ->
    if($(this).val())
      $(@).closest(".category-body").find(".divide-ul li").hide().filter(":contains('" + ( $(this).val() ) + "')").show()
    else
      $(@).closest(".category-body").find(".divide-ul li").show()

  stopEdit: ->
    $(".category-edit-form").hide()
    $(".normal-status").show()

  categoryEditFormClick: (event)->
    event.stopPropagation()

  popFrontBindModule: (categoryData, categoryContainer)->
    status = true
    $.ajax
      url: Store.context + "/api/admin/frontCategories/#{categoryData.id}/mapping"
      type: "GET"
      async: false
      success: (bindData)->
        channel = $(".category").data("channel")
        if _.isEmpty bindData.data
          $(".front-area").remove()
          json = {"data": "", "frontCategoryData": categoryData}
          if categoryData.level is (that.categoryType.maxLength - 1)
            $(".category-#{that.categoryType.maxLength}").addClass("category-last")
        else
          level = parseInt(categoryData.level) + 1
          $(".category-#{categoryData.level} .selected .js-delete-category").hide()
          $(".category-#{level}").remove()
          json = {"data": bindData, "frontCategoryData": categoryData,"channel": channel}
        $(".front-area").remove()
        $(".edit-area").append("""<div class="front-area"></div>""")
        $(".front-area").append(categoryBind({"data": json, "channel": channel}))
        bindComponent = require("front_category_bind/view")
        $(document).unbind "confirm:delete-bind"
        new bindComponent()
      complete: ->
        $(categoryContainer).spin(false)

  renderNextCategory: (categoryData, hasChild, categoryContainer)->
    if hasChild
      $.ajax
        url: "#{that.categoryType.url}/#{parseInt(categoryData.id)}/children"
        type: "GET"
        success: (data)=>
          $(".category-container").append(categoryTemplate({
            extras: {
              "categoryLevel": parseInt(categoryData.level) + 1,
              "parentId": categoryData.id,
              "type": that.categoryType.type
            }, data: data
          }))
          #setHeight()
          $(categoryContainer).spin(false)
        complete: ->
          $(categoryContainer).spin(false)
    else
      $(".category-container").append(categoryTemplate({
        extras: {
          "categoryLevel": parseInt(categoryData.level) + 1,
          "parentId": categoryData.id,
          "type": that.categoryType.type
        }
      }))
      #setHeight()
      $(categoryContainer).spin(false)

  schedule: (categoryData, categoryContainer)->
    if categoryData.level < that.categoryType.maxLength
      $(".edit-panel").addClass("disable")
      $(".menu-panel").remove()
      $(".js-spu-new").removeAttr "disabled"
      $(".js-add-attribute").removeAttr "disabled"
      $(".js-add-attribute").css("pointer-events", "all")
      $(".manage-li").removeClass("active")
      $(".attribute-manage").addClass("active")
      $(".manage-div").removeClass("active")
      $("#edit-category").addClass("active")
      $(".front-area").remove()
      if categoryData["hasChild"] is true
        that.renderNextCategory(categoryData, true, categoryContainer)
      else if that.categoryType.type is -1 and categoryData["hasChild"] is false
        if !that.backCategoryNextSelect(categoryData, categoryContainer)
          that.renderNextCategory(categoryData, false, categoryContainer)
      else if that.categoryType.type is 1 and categoryData["hasChild"] is false
        that.renderNextCategory(categoryData, false, categoryContainer)
        that.popFrontBindModule(categoryData, categoryContainer)
    else if that.categoryType.type is -1
      $(".category-#{categoryData.level}").addClass("category-last")
      that.renderEditPanel(categoryData, categoryContainer)
    else if that.categoryType.type is 1
      $(".category-#{categoryData.level}").addClass("category-last")
      that.popFrontBindModule(categoryData, categoryContainer)

  nextCategory: ->
    categoryId = $(@).attr "id"
    $(".spu-manage").removeClass("active")
    $(".attribute-manage").addClass("active")
    $("#edit-category").addClass("active")
    $("#spu-manage").removeClass("active")
    $(".category-id-show").text(categoryId)
    $(this).parents(".category").nextAll(".category").remove()
    categoryData = $(@).data("category")
    $(@).addClass("selected")
    $(@).siblings().removeClass("selected")
    $(@).removeClass("mouseover")
    $(@).closest(".category-container").spin("medium")
    that.schedule(categoryData, $(@).closest(".category-container"))

  backCategoryNextSelect: (categoryData, categoryContainer)->
    status = false
    if categoryData.level isnt 3
      return status
    $.ajax
      url: Store.context + "/api/admin/categories/#{categoryData.id}/keys"
      type: "GET"
      async: false
      success: (data)->
        that.renderEditPanel(categoryData, categoryContainer)
        if !_.isEmpty data.data
          if categoryData.level is (that.categoryType.maxLength - 1)
            $(".category-#{that.categoryType.maxLength}").addClass("category-last")
          status = true
    status

  renderEditPanel: (categoryData, categoryContainer)->
    $(".attribute-list").empty()
    $(".spu-list").empty()
    spuStatus = false
    keyStatus = false
    attrData = ""
    spuData = ""
    $.ajax
      url: Store.context + "/api/admin/categories/#{categoryData.id}/keys"
      type: "GET"
      success: (data)->
        keyStatus = true
        $(".attribute-list").append(attributeManageTemplate(data: data))
        $(".category-#{that.categoryType.maxLength}").addClass("category-last")
        if keyStatus and spuStatus
          $(categoryContainer).spin(false)
      error: (data)->
        new Modal(
          "icon": "error"
          "title": "出错啦！"
          "content": data.responseText || "未知故障"
        ).show()
        $(categoryContainer).spin(false)

    $.ajax
      url: Store.context + "/api/admin/backCategories/#{categoryData.id}/spus"
      type: "GET"
      success: (data)->
        spuStatus = true
        $(".spu-list").append(spuManageTemplate(data: data))
        if keyStatus and spuStatus
          $(categoryContainer).spin(false)
      error: (data)->
        new Modal(
          "icon": "error"
          "title": "出错啦！"
          "content": data.responseText || "未知故障"
        ).show()
        $(categoryContainer).spin(false)
    $("div.edit-panel #edit-category").attr "category-id", categoryData.id
    $("div.edit-panel #spu-manage").attr "category-id", categoryData.id
    $("div.edit-panel #spu-manage").attr "category-level", categoryData.level
    $(".edit-panel").removeClass("disable")

  addCategory: ->
    newCategory = $(@).closest(".category-form")
    if $.trim(newCategory.find(".js-new-category").val()) is ""
      that.tip($(newCategory), "error", "down", "类目名称不能为空")
      $(".tip").css("top", -35)
      newCategory.find(".js-new-category").focus()
    else
      $.ajax
        url: "#{that.categoryType.url}/add"
        type: "POST"
        data: newCategory.serialize()
        dataType: "json"
        success: (data)=>
          data.data["hasChild"] = false
          data.data["level"] = $(@).closest("div.category").attr "id"
          if data.data["level"] isnt "1"
            if $(".category-list").find("li##{data.data.parentId}").data("category").hasChild is false
              $(".category-list").find("li##{data.data.parentId}").data("category").hasChild = true
              $(".category-list").find("li##{data.data.parentId}").find(".operate-status.js-delete-category").remove()
          else
            data.data.type = that.categoryType.type
          $(@).parents("div.bottom-add-category").siblings("ul.divide-ul").append(categoryItemTemplate(data.data))
          $(".js-new-category").val("")
          $(".front-category-bind").remove()

  updateCategory: ->
    categoryData = $(@).closest("li.divide-li").data("category")
    name = $(@).closest("form.update-category-group").find(".update-category-input").val()
    parent = $(@).closest("li.divide-li")
    if name is ""
      that.tip($(parent), "error", "up", "类目名不得为空")
      $(".tip").css("top", 40)
      return
    if _.isEqual(categoryData.name,name)
      $(@).closest("li.divide-li").find(".update-category-group").css("display", "none")
      $(@).closest("li.divide-li").find(".normal-status").css("display", "block")
      return
    $.ajax
      url: "#{that.categoryType.url}/update/#{categoryData.id}"
      type: "POST"
      data: $(@).closest("form.update-category-group").serialize()
      success: =>
        $(@).closest("li.divide-li").find(".update-category-group").css("display", "none")
        $(@).closest("li.divide-li").find(".normal-status").css("display", "block")
        $(@).closest("li.divide-li").find(".item-pop span").text(name)
        $(@).closest("li.divide-li").find(".item-pop").attr("title",name)
        $(@).closest("li.divide-li").data("category")["name"] = name

  editCategory: (event)->
    event.stopPropagation()
    $(".update-category-group").css "display", "none"
    $(".normal-status").css "display", "block"
    $(@).closest("li.divide-li").find(".normal-status").css("display", "none")
    unchangedName = $(@).closest("li.divide-li").find(".normal-status .item-pop span").html()
    $(@).closest("li.divide-li").find(".update-category-group").css("display", "block")
    if $(@).closest("li.divide-li").find(".update-category-group").width() < 140
      $(@).closest("li.divide-li").find(".update-category-group .update-category-input").addClass("short-input")
    else
      $(@).closest("li.divide-li").find(".update-category-group .update-category-input").removeClass("short-input")
    $(@).closest("li.divide-li").find(".update-category-group .update-category-input").val(unchangedName)

  deleteCategoryConfirm: (event,data)->
    event.stopPropagation()
    url = ""
    #categoryItem = $(@).closest("li").data("category")
    categoryItem=JSON.parse(data)
    #代替源代码this指针
    thisItem=$(".js-delete-category[data-categoryid=#{categoryItem.id}]")
    if that.categoryType["type"] is 1
      url = Store.context + "/api/admin/frontCategories/#{categoryItem.id}/mapping"
    else if that.categoryType["type"] is -1
      url = Store.context + "/api/admin/backCategories/#{categoryItem.id}/spus"
    $.get url, (bindData)=>
      if _.isEmpty bindData.data
        $.ajax
          url: "#{that.categoryType.url}/del/#{categoryItem.id}"
          type: "POST"
          success: (data)=>
            if categoryItem.parentId isnt 0 and $(thisItem).closest("li").siblings(".divide-li").length is 0
              $(".category-list").find("li##{categoryItem.parentId}").data("category").hasChild = false
              $(".category-list").find("li##{categoryItem.parentId}").find("span.operate-span").append("""<span class="operate-status js-delete-category"><i class="fa fa-fw fa-trash-o"></i></span>""")
              $(thisItem).closest(".divide-li").remove()
            else
              $(thisItem).closest(".divide-li").remove()
      else
        parent = $(thisItem).closest("li.divide-li")
        if that.categoryType["type"] is 1
          that.tip($(parent), "error", "up", "该类目已绑定")
        else
          that.tip($(parent), "error", "up", "该类目已有spu")
        $(parent).trigger("click")

     
    
    
    
    
module.exports = backCategories
