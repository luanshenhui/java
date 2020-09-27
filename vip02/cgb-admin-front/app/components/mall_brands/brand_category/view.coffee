tipAndAlert = require "tip_and_alert/tip_and_alert"
Modal = require "spirit/components/modal"
Store = require "extras/store"

class BrandsInfo
  _.extend @::, tipAndAlert
  editBrandCategoryTemplates = App.templates["add_brand_category"]
  viewBrandCategoryTemplates = App.templates["view_brand_category"]
  constructor: ->
    @addBrandCategoryBtn = $(".js-brandCategory-add")
    @editBrandCategoryBtn = $(".js-brandCategory-edit")
    @viewBrandCategoryBtn = $(".js-brandCategory-view")
    @approveMemeo = ".js-approve-memeo"
    @bindEvent()
  that = this
  bindEvent: ->
    that = this
    @addBrandCategoryBtn.on "click", @addBrandCategory
    @editBrandCategoryBtn.on "click", @editBrandCategory
    @viewBrandCategoryBtn.on "click", @viewBrandCategory
    $(document).on "keyup", @approveMemeo, @remainingText
    $(document).on "blur", @approveMemeo, @remainingText
    $(document).on "confirm:delete-categories", @delBrandCategories

  addBrandCategory: ->
    new Modal(editBrandCategoryTemplates({title: "新建品牌分类"})).show()
    $("form.add-brand-category-form").validator
      isErrorOnParent: true
    $("form.add-brand-category-form").on "submit", that.brandCategoryAdd

  brandCategoryAdd: (evt)->
    evt.preventDefault()
    $("form.add-brand-category-form").validator
      isErrorOnParent: true
    data = $(".add-brand-category-form").serializeObject()
    $.ajax
      url: Store.context + "/api/admin/brandCategories/add-categories"
      type: "POST"
      data: data
      success: (data)->
        window.location.reload()

  editBrandCategory: (evt)->
    data = $(@).closest("tr").data("data")
    new Modal(editBrandCategoryTemplates({title: "编辑品牌分类",data:data})).show()
    $("form.add-brand-category-form").validator
      isErrorOnParent: true
    $("form.add-brand-category-form").on "submit", that.brandCategoryEdit

  brandCategoryEdit: (evt)->
    evt.preventDefault()
    $("form.add-brand-category-form").validator
      isErrorOnParent: true
    data = $(".add-brand-category-form").serializeObject()
    $.ajax
      url: Store.context + "/api/admin/brandCategories/update-categories"
      type: "POST"
      data: data
      success: (data)->
        window.location.reload()


  brandCategoryUpdate: (evt)->
    evt.preventDefault()
    $("form.add-brand-category-form").validator
      isErrorOnParent: true
    data = $(".add-brand-category-form").serializeObject()
    $.ajax
      url: Store.context + "/api/admin/brandCategories/update-categories"
      type: "POST"
      data: data
      success: (data)->
        window.location.reload()

  viewBrandCategory: (evt)->
    data = $(@).closest("tr").data("data")
    new Modal(viewBrandCategoryTemplates({title: "查看品牌分类",data:data})).show()
    @remainingText

  delBrandCategories: (evt,id)->
    evt.preventDefault()
    $.ajax
      url: Store.context + "/api/admin/brandCategories/delete-categories"
      data:
        id: id
      type: "POST"
      async: false
      success: (data)->
        if data.data is true
          window.location.reload()

# textarea ie兼容问题
  remainingText: ->
    val = $("#descript").val()
    length = parseInt(val.length)
    text = 40 - length
    if length >= 40
      $(@).val(val.substr(0, 40))
      text = 0
    $(".remaining-text i").text(text)

module.exports = BrandsInfo