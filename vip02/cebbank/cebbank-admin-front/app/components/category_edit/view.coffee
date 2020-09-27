Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"

attrValueUpdateTemplate = App.templates.category_edit.templates["attribute_value_update"]
attrValueViewTemplate = App.templates.category_edit.templates["attribute_value_view"]
spuPropertiesViewTemplate = App.templates.category_edit.templates["spu_properties_view"]
attrValueItemTemplate = App.templates.category_edit.templates["_attribute_value_item"]
spuNewTemplate =App.templates.category_edit.templates["createSPU"]
attrCreateTemplate = App.templates.category_edit.templates["attribute_create"]
categoryKeyTemplate = App.templates.category_edit.templates["_back_category_key"]
spuItemTemplate = App.templates.category_edit.templates["_spu_item"]
class cateGoryEdit

  _.extend @::, TipAndAlert

  constructor: ->
    @switchPanel = (".tab a.switch-panel")
    @spuAttributeWatch = (".js-spu-attr-get")
    @spuNew = (".js-spu-new")
    @attributeUpdate = (".js-update-attribute")
    @editCancel = (".js-edit-cancel")
    @attrValueEdit = (".js-attr-edit")
    @menuCancel = (".js-menu-cancel")
    @attrAdd = (".js-add-attribute")
    @attrDelete = (".js-delete-attribute")
    @attrValueWatch = (".js-attr-value-get")
    @spuCreate = ".js-create-spu"
    @spuDelete = ".js-spu-delete"
    @spuUpdate = ".js-spu-update"
    @isSpu = "input[name=isSpu]"
    @isSku = "input[name=isSku]"
    @brandSearch = "input.js-search-brand"
    @categorySearch = (".js-search-item-input")

    @bindEvent()

  that = this

  bindEvent: ->
    that = this
    $(".edit-panel").on "click", @switchPanel, @switchTab
    $(".edit-panel").on "click", @attrValueWatch, @renderAttributeValue
    $(".edit-panel").on "click", @spuNew, @renderSPUNew
    $(".edit-panel").on "click", @attributeUpdate, @updateAttribute
    $(".edit-panel").on "click", @editCancel, @updateCancel
    $(".edit-panel").on "click", @attrValueEdit, @renderAttrValueEdit
    $(".edit-panel").on "click", @attrAdd, @addAttribute
    $(".edit-panel").on "click", ".js-attribute-cancel", @removeAddAttribute
    $(".edit-panel").on "click", @spuCreate, @createSPU
    $(".edit-panel").on "change", @isSpu, @getSpuProperty
    $(".edit-panel").on "change", @isSku, @getSkuProperty
    $(".edit-panel").on "click", @spuAttributeWatch, @renderSPUAttribute
    $(document).on "confirm:deleteAttribute", @confirmDeleteAttribute
    $(document).on "confirm:deleteSpu", @confirmDeleteSpu
    $(".edit-panel").on "click", @spuUpdate, @renderUpdateSPU
    $(document).on "mouseout", ".dropdown-group", @hideDropdownMenu
    $(document).on "mouseover", ".dropdown-group", @showDropDownMenu
    $(document).on "keyup", @brandSearch, @searchBrand
    $(".edit-panel").on "keyup", @categorySearch, @categorySearchItem

  searchBrand: ->
    if !_.isEmpty $(@).val()
      $(@).closest(".select-spu-brand").find("#spu-brand-id option").prop("selected", false).filter(":contains('" + ( $(@).val()) + "')").prop("selected", true)
    else
      $(@).closest(".select-spu-brand").find("#spu-brand-id option").prop("selected", false)

  categorySearchItem: ->
    if !_.isEmpty $(@).val()
      $(@).closest("#spu-manage").find(".spu-list li").hide().filter(":contains('" + ( $(this).val() ) + "')").show()
    else
      $(@).closest("#spu-manage").find(".spu-list li").show()


  showDropDownMenu: ->
    $(@).find(".dropdown-title").css("z-index", 99)
    $(@).find(".dropdown-menu").removeClass("hide")
    height = $(@).find(".dropdown-btn").height() + $(@).find(".dropdown-menu").height()
    $(@).find(".dropdown-title").css("height", height)
    $(@).closest("li").siblings("li").css("pointer-events", "none")

  hideDropdownMenu: ->
    $(@).find(".dropdown-title").css("z-index", 9)
    $(@).find(".dropdown-menu").addClass("hide")
    height = $(@).find(".dropdown-btn").height()
    $(@).find(".dropdown-title").css("height", height)
    $(@).closest("li").siblings("li").css("pointer-events", "all")

  switchTab: (event)->
    event.preventDefault()
    $(@).parent().addClass "active"
    $(@).parent().siblings().removeClass "active"
    $("div#{$(@).attr "href"}").siblings().find("button").removeAttr "disabled"
    $("div#{$(@).attr "href"}").siblings().find(".menu-panel").remove()
    $("div#{$(@).attr "href"}").siblings().find(".spu-list").removeAttr "pointer-events"
    $("div#{$(@).attr "href"}").addClass "active"
    $("div#{$(@).attr "href"}").siblings().removeClass "active"

  confirmDeleteAttribute: (event, data)->
    closestLi = $("#edit-category ##{data}").closest("li")
    categoryId = $("#edit-category").attr "category-id"
    $.ajax
      url: Store.context + "/api/admin/categories/#{categoryId}/keys/#{data}"
      type: "POST"
      success: =>
        closestLi.remove()
        _.each $(".attribute-li"), (li, i)->
          $(li).find(".attribute-number").text(i + 1)

  confirmDeleteSpu: (event, data)->
    closestLi = $("#spu-manage button##{data}").closest("li.spu-item-li")
    spu = closestLi.data("spu")
    $.get  Store.context + "/api/admin/spus/#{spu.id}/goods", (data)=>
      if data.data is 0
        $.ajax
          url: Store.context + "/api/admin/spus/#{spu.id}/del"
          type: "POST"
          success: =>
            closestLi.remove()
      else
        that.tip($(closestLi), "error", "up", "该产品已绑定商品")
        $(".tip").css("top", 35)

  addAttribute: ->
    categoryId = $(@).parent().attr "category-id"
    $(@).attr "disabled", true
    $(@).siblings("ul").prepend(attrCreateTemplate())
    $(".add-attr-li").closest("#edit-category").find(".js-add-attribute").css("pointer-events", "none")
    $(".add-attr-li").closest("ul").find(".attribute-li").css("pointer-events", "none")
    $(".js-create-attribute").on "click", ->
      attributes = []
      _.each $(@).closest(".add-attr-li").siblings(".attribute-li"), (li)->
        attributes.push $(li).find(".attr").data("name")
      form = $(@).parents(".add-attribute-form")

      if $.trim(form.find(".update-category-input").val()) is ""
        parent = form.find(".input-group")
        that.tip($(parent), "error", "up", "属性名不能为空")
        $(".tip").css("top", 35)
      else if _.contains attributes, $(@).closest(".input-group").find("input.update-category-input").val()
        parent = form.find(".input-group")
        that.tip($(parent), "error", "up", "属性重名")
        $(".tip").css("top", 35)
      else if $(@).closest(".input-group").find("input.update-category-input").val() is "品牌"
        parent = form.find(".input-group")
        that.tip($(parent), "error", "up", "属性名不能为品牌")
        $(".tip").css("top", 35)
      else if $(@).closest(".input-group").find("input.update-category-input").val().length > 5
        parent = form.find(".input-group")
        that.tip($(parent), "error", "up", "属性名长度大于5")
        $(".tip").css("top", 35)
      else
        $.ajax
          url: Store.context + "/api/admin/categories/#{categoryId}/keys"
          type: "POST"
          dataType: "json"
          data: form.serialize()
          success: (data)=>
            attributeLength = $(".attribute-li").length
            data.data.index = attributeLength + 1
            $(".add-attr-li").closest("ul").find(".attribute-li").css("pointer-events", "all")
            $(".add-attr-li").closest("#edit-category").find(".js-add-attribute").css("pointer-events", "all")
            $("#edit-category ul .add-attr-li").remove()
            $("#edit-category ul").append(categoryKeyTemplate(data.data))
            $(".js-add-attribute").removeAttr "disabled"

  removeAddAttribute: ->
    $(".add-attr-li").closest("ul").find(".attribute-li").css("pointer-events", "all")
    $(".add-attr-li").closest("#edit-category").find(".js-add-attribute").css("pointer-events", "all")
    $(".js-add-attribute").removeAttr "disabled"
    $(@).parents(".add-attr-li").remove()
    if $(".add-attribute-form").length > 0
      $(".add-attribute-form").closest("ul").find(".attribute-li").css("pointer-events", "none")

  renderSPUAttribute: ->
    spu = $(@).closest("li").data("spu")
    brandStatus = false
    attributeStatus = false
    brandName = ""
    attributes = {}
    $.get Store.context + "/api/admin/spus/#{spu.id}/brand", (data)=>
      brandName = data.data.brandName
      brandStatus = true
      if brandStatus and attributeStatus
        $(@).parent().append(spuPropertiesViewTemplate(data: {brandName: brandName, attributes: attributes}))
        $(".dropdown-menu").addClass("hide")
        $(".menu-panel").attr "disabled", false
        $(".menu-panel").css("left", "0em").css "width", $(@).parent().parent().width()
        $(".menu-panel").on "mouseleave", ->
          $(@).remove()
    $.get Store.context + "/api/admin/spus/#{spu.id}", (data)=>
      attributeStatus = true
      attributes = data.data.attributes
      if brandStatus and attributeStatus
        $(@).parent().append(spuPropertiesViewTemplate(data: {brandName: brandName, attributes: attributes}))
        $(".dropdown-menu").addClass("hide")
        $(".menu-panel").attr "disabled", false
        $(".menu-panel").css("left", "0em").css "width", $(@).parent().parent().width()
        $(".menu-panel").on "mouseleave", ->
          $(@).remove()

  renderAttributeValue: ->
    categoryId = $("#edit-category").attr "category-id"
    attributeKeyId = $(@).closest("li").data("attribute").id
    $.get Store.context + "/api/admin/categories/#{categoryId}/keys/#{attributeKeyId}/values", (data)=>
      if _.isEmpty(data.data)
        data.data = [{"id": -1, "value": "属性值为空 请添加属性值"}]
      $(@).parent().append(attrValueViewTemplate(data: data))
      $(".menu-panel").attr "disabled", false
      $(".menu-panel").css("left", "0em").css "width", $(@).parent().width()
      $(".menu-panel").on "mouseleave", ->
        $(@).remove()

  renderSPUNew: ->
    brandStatus = false
    attributeStatus = false
    brandData = ""
    attributeData = ""
    channel = $(".category-1").data("channel")
    categoryId = $("#spu-manage").attr "category-id"
    $.get Store.context + "/api/admin/categories/#{categoryId}/keys", (data)->
      attributeStatus = true
      attributeData = data
      if attributeStatus and brandStatus
        $("#spu-manage").append(spuNewTemplate({attribute: attributeData, brand: brandData}))
        $(".menu-panel").css("left", "0em").css("top", "3em")
        $(".menu-panel").find(".create-spu-form").attr "category-id", categoryId
        $(".spu-list").css("pointer-events", "none")
    $.get Store.context + "/api/admin/brands",{channel:channel}, (data)->
      brandStatus = true
      brandData = data
      if attributeStatus and brandStatus
        $("#spu-manage").append(spuNewTemplate({attribute: attributeData, brand: brandData}))
        $(".menu-panel").css("left", "0em").css("top", "3em")
        $(".menu-panel").find(".create-spu-form").attr "category-id", categoryId
        $(".spu-list").css("pointer-events", "none")
    $(@).attr "disabled", true
    $(document).on "click", ".js-menu-cancel", =>
      $(".menu-panel").remove()
      $(".spu-list").css("pointer-events", "all")
      $(@).attr "disabled", false

  createSPU: ->
    categoryId = $("#spu-manage").attr "category-id"
    categoryLevel = $("#spu-manage").attr "category-level"
    unEnum = $(".spu-property input[name=value][required=required]")
    isSkuLength = $('input[name="isSku"]:checked').length
    if $('#spu-name').val() is ""
      that.tip $("#spu-name").parent(), "error", "up", "SPU名称不能为空"
      $('#spu-name').focus()
    else if _.isEmpty $("#spu-brand-id").val()
      that.tip $("#spu-brand-id").parent(), "error", "up", "SPU品牌不能为空"
      $(".tip").css("left", 137).css("top", 35)
    else if isSkuLength = 0 or isSkuLength > 2 or !isSkuLength
      that.tip $(".spu-attr"), "error", "up", "至少选择1个或2个销售属性"
      $(".tip").css("top", 40).css("width", 200)
    else if unEnum.val() is ""
      that.tip unEnum.parent(), "error", "up", "不可枚举属性的值必填"
      $(".tip").css("margin-top", 0).css("left", 0).css("top", 40)
    else
      spu = {
        id: $('#spu-id').val(),
        name: $('#spu-name').val(),
        categoryId: categoryId,
        brandId: $("#spu-brand-id").val()
      }
      attributes = _.map(_.select($('.spu-property-list'), (item) ->
        $(item).find('input[name="isSpu"]').prop('checked')
      ), (item)->
        attributeKeyId = $(item).data("id")
        ###属性名id###
        isSku = if $(item).find('input[name="isSku"]').prop('checked') then true else false
        ###是否是销售属性###
        type = $(item).find('*[name="value"]').data('type')
        ###属性类型 1可枚举  空不可枚举###
        value = $(item).find('*[name="value"]').val()
        ######
        {attributeKeyId: attributeKeyId, type: type, value: value, isSku: isSku}
      )
      data = {spu: spu, attributes: attributes}
      type = "POST"
      url= "/api/admin/add/spus"
      if(spu["id"])
        type = "post"
        url= "/api/admin/update/spus"
      else
        delete spu["id"]
      $.ajax
        type: type
        url: Store.context + url
        data: {
          data: JSON.stringify(data)
        }
        success: (data)=>
          if type is "POST"
            $(".menu-panel").remove()
            $("#spu-manage ul").append(spuItemTemplate(data.data))
            $(".category-#{categoryLevel}").nextAll(".category").remove()
            $(".js-spu-new").attr "disabled", false
            $("ul.spu-list").css("pointer-events", "all")

          else
            $(@).closest("li.spu-item-li").find("span.spu-name").text(spu.name)
            $(@).closest("li.spu-item-li").data("spu")["name"] = spu.name
            $(@).closest("li").data("spu")["brandId"] = spu.brandId
            $(".menu-panel").remove()
            $("ul.spu-list li.spu-item-li span.operate.on-hover").css("pointer-events", "all")
            $("ul.spu-list li.spu-item-li").css("pointer-events", "all")
            $("ul.spu-list").css("pointer-events", "all")
            $(".js-spu-new").attr "disabled", false

  renderUpdateSPU: ->
    channel=$(".category-1").data("channel")
    $(".js-spu-new").attr "disabled", true
    $(".menu-panel").remove()
    $(@).closest("li").siblings("li.spu-item-li").css("pointer-events", "none")
    $(@).parent().css("pointer-events", "none")
    categoryId = $("#spu-manage").attr "category-id"
    spuData = $(@).parent().parent().data("spu")
    brandData = ""
    $.ajax
      url: Store.context + "/api/admin/brands"
      type: "GET"
      data:channel:channel
      async: false
      success: (data)->
        brandData = data
    $.get Store.context + "/api/admin/categories/#{categoryId}/keys", (data)=>
      $(@).parent().parent().append(spuNewTemplate({spu: spuData, attribute: data, brand: brandData}))
      $(".menu-panel").css("left", "0em").css("top", "3em")
      $(".menu-panel").find(".create-spu-form").attr "category-id", categoryId
      $(".js-create-spu").text("更新")
      $.get (Store.context + "/api/admin/spus/#{spuData.id}"), (data) ->
        $.each data.data.attributes, (i, d)->
          $(".spu-property-list#key-#{d.attributeKeyId}").find("input[name=isSpu]").prop("checked", true)
          $(".spu-property-list#key-#{d.attributeKeyId}").find(".spu-attribute span").addClass("span-active")
          if d.isSku is true
            $(".spu-property-list#key-#{d.attributeKeyId}").find('input[name="isSku"]').css("display", "inline").removeAttr("disabled")
            $(".spu-property-list#key-#{d.attributeKeyId}").find("span.setSku").css("display", "inline")
            $(".spu-property-list#key-#{d.attributeKeyId}").find("input[name=isSpu]").attr("disabled", true)
            $(".spu-property-list#key-#{d.attributeKeyId}").find('input[name="isSku"]').prop("checked", true).attr("disabled", true)
          else
            $(".spu-property-list#key-#{d.attributeKeyId}").find('input[name=value]').removeAttr("disabled").attr("required", "true").css("display", "inline").val(d.value)
            $(".spu-property-list#key-#{d.attributeKeyId}").find('select[name=value]').removeAttr("disabled").css("display", "inline")
          selectColumn = $(".spu-property-list#key-#{d.attributeKeyId}").find('select[name=value]')
          $.ajax
            type: "GET"
            url: Store.context + "/api/admin/categories/#{categoryId}/keys/#{d.attributeKeyId}/values"
            success: (data)->
              selectColumn.empty()
              _.each data.data, (item) ->
                if d.value is item.value
                  selectColumn.append("<option value=#{item.id} selected>#{item.value}</option>")
                else
                  selectColumn.append("<option value=#{item.id}>#{item.value}</option>")
      $(document).on "click", ".js-menu-cancel", ->
        $(".js-spu-new").removeAttr "disabled"
        $(".menu-panel").remove()
        $("ul.spu-list li.spu-item-li span.operate.on-hover").css("pointer-events", "all")
        $("ul.spu-list li.spu-item-li").css("pointer-events", "all")

  getSpuProperty: ->
    categoryId = $(@).parents(".create-spu-form").attr "category-id"
    if $(@).prop("checked")
      changeSpuPropertyListStatus(@, 1)
      selectColumn = $(@).parents('.spu-property-list:first').find('select')
      keyId = $(@).parents('.spu-property-list:first').data('id')
      selectColumn.removeAttr("disabled").css("display", "inline")
      if $(@).closest("tr").data("type") is 1
        $.ajax
          type: "GET"
          url: Store.context + "/api/admin/categories/#{categoryId}/keys/#{keyId}/values"
          success: (data)=>
            if _.isEmpty data.data
              that.tip $(@).closest("tr"), "error", "up", "属性值为空，请返回添加属性值！"
              $(@).prop "checked", false
              changeSpuPropertyListStatus(@, 0)
            else
              selectColumn.empty()
              _.each data.data, (item) ->
                selectColumn.append("<option value=#{item.id}>#{item.value}</option>")
    else
      changeSpuPropertyListStatus(@, 0)

  changeSpuPropertyListStatus = (item, status)->
    if status
      $(item).closest(".spu-attribute").find("span").addClass("span-active")
      if _.isEmpty($(".create-spu-form").find("#spu-id").val())
        $(item).parents('.spu-property-list:first').find('input[name="isSku"]').removeAttr("disabled").css("display", "inline")
        $(item).parents('.spu-property-list:first').find('.setSku').css("display", "inline")
      $(item).parents('.spu-property-list:first').find('*[name="value"]').removeAttr("disabled").attr("required", "true").css("display", "inline")
    else
      $(item).closest(".spu-attribute").find("span").removeClass("span-active")
      $(item).parents('.spu-property-list:first').find('input[name="isSku"]').attr("disabled", true).css("display", "none").prop("checked", false)
      $(item).parents('.spu-property-list:first').find('*[name="value"]').attr("disabled", true).removeAttr("required").css("display", "none")
      $(item).parents('.spu-property-list:first').find('.setSku').css("display", "none")
      $(item).parents('.spu-property-list:first').find('select').empty().css("display", "none")

  getSkuProperty: ->
    if $(@).prop('checked')
      $(@).parents('.spu-property-list:first').find('*[name="value"]').attr("disabled", true).css("display", "none")
    else
      $(@).parents('.spu-property-list:first').find('*[name="value"]').removeAttr("disabled").css("display", "inline")

  updateAttribute: ->
    li = $(@).closest("li")
    li.siblings().css("pointer-events", "none")
    text = li.find("span.attr").text()
    $(@).closest("li").find("span.attr").replaceWith("""<span class="attr"><input class="input-small" type="text" name="" placeholder="请输入属性" value="#{text}"></span>""")
    $(@).closest("li").find("span.is-enum").prepend("""<input type="checkbox" value="">""")
    li.find("span.operate.edit-status").addClass("active-status").removeClass("disable-status")
    li.find(".operate.on-hover").addClass("disable-status").removeClass("active-status")
    li.find(".end").addClass("disable-status")

  updateCancel: ->
    li = $(@).closest("li")
    li.siblings().css("pointer-events", "all")
    text = li.find("span.attr>input").val()
    $(@).closest("li").find("span.attr").replaceWith("""<span class="attr">#{text}</span>""")
    $(@).closest("li").find("span.is-enum > input[type=checkbox]").remove()
    li.find("span.operate.edit-status").addClass("disable-status").removeClass("active-status")
    li.find(".operate.on-hover").removeClass("disable-status")
    li.find(".end").removeClass("disable-status")

  renderAttrValueEdit: ->
    categoryId = $("#edit-category").attr "category-id"
    attributeKeyId = $(@).closest("li").data("attribute").id
    $(@).closest("li").siblings("li").css("pointer-events", "none")
    $(@).closest(".operate.on-hover").addClass("active-status")
    $.get Store.context + "/api/admin/categories/#{categoryId}/keys/#{attributeKeyId}/values", (data)=>
      $(@).parent().append(attrValueUpdateTemplate(data: data))
      $(".menu-panel").css("left", "0em").css "width", $(@).parent().width()
      $(".menu-panel").on "click", ".js-menu-cancel", ->
        $(".operate.on-hover").removeClass("active-status")
        $(".menu-panel").remove()
        $("li.attribute-li").css("pointer-events", "all")
      $(".menu-panel").on "click", ".js-add-attr-value", ->
        if $.trim($(@).parent().prev().val()) is ""
          that.tip $(@).closest("form"), "error", "up", "类目属性值不能空！"
          $(".tip").css("top", 35)
          return
        status = true
        for i in $("input.attribute-show")
          if $(".properties-edit-form").find("input[name=data]").val() is $(i).val()
            that.tip $(@).closest("form"), "error", "up", "类目属性值重名！"
            $(".tip").css("top", 35)
            status = false
            break
        if status
          $(@).closest(".properties-edit").spin("medium")
          $.ajax
            url: Store.context + "/api/admin/categories/#{categoryId}/keys/#{attributeKeyId}/values"
            type: "POST"
            data: $(@).closest(".properties-edit-form").serialize()
            success: (data) =>
              $(@).closest(".properties-edit").find(".add-properties-li").before(attrValueItemTemplate(data.data))
              $(@).parent().siblings("input[name=data]").val("")
            complete: =>
              $(@).closest(".properties-edit").spin(false)
    $(document).off("click",".js-attribute-value-delete")
    $(document).on "click", ".js-attribute-value-delete", ->
      attrValueData = $(@).closest("li").data("attrValue")
      $.ajax
        url: Store.context + "/api/admin/categories/#{categoryId}/keys/#{attributeKeyId}/values/#{attrValueData.id}"
        type: "POST"
        success: =>
          $(@).closest("li").remove()

module.exports = cateGoryEdit