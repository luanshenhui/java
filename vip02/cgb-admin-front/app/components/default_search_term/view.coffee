Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
tipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"

class defaultSearchTerm
  _.extend @::, tipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
    @defaultTermNew = ".js-default-term-new"
    @defaultTermCreate = ".js-default-term-create"
    @defaultTermEdit = ".js-default-term-edit"
    @componentForm = ".default-term-form"
    @bindEvent()
  newDefaultTermTemplate = App.templates["default_search_term_new"]
  that = this

  bindEvent: ->
    that = this
    $(".default_search_term").on "click", @defaultTermNew, @newTerm
    $(".default_search_term").on "click", @defaultTermEdit, @editTerm
    $(document).on "confirm:delete-item", @deleteConfirm

  newTerm: =>
    component = new Modal newDefaultTermTemplate({add:true})
    component.show()
    $(that.componentForm).validator
      isErrorOnParent: true
    $("form.default-term-form").on "submit", that.createDefaultTerm

  #新增
  createDefaultTerm: (evt)->
    $(that.componentForm).validator()
    ###新增逻辑###
    val = $("input[type='checkbox']:checked");
    if val.is(":checked")
      $("#status").attr("value", "0")
    else
      $("#status").attr("value", "1")
    $("form.default-term-form").validator()
    evt.preventDefault()
    data = $("form.default-term-form").serializeObject();

#    if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.name #默认搜索词名称
#      that.tip $("#termName").parent(),"error", "up", "不能输入特殊字符！"
#      $(".tip").css("left", 180).css("top", 36).css("width", 150)
#      return
    $.ajax
      url: Store.context + "/api/admin/defaultSearchTerm/add"
      type: "POST"
      dataType:"JSON"
      data: $("form.default-term-form").serialize()
      success: (data)->
        window.location.reload()
  #编辑
  editTerm: ->
    defaultTerm = $(@).closest("tr").data("data")

    defaultTemplate = new Modal newDefaultTermTemplate({title:"edit",data: defaultTerm})
    defaultTemplate.show()
    if (defaultTerm.status == '0')
      $("input[name='status']").prop('checked', "checked")
    $(that.componentForm).validator
      isErrorOnParent: true
    $("form.default-term-form").on "submit", that.editConfirm

  editConfirm: (event)->
    $(that.componentForm).validator()
    id = $(".js-default-term-name").data("id")
    event.preventDefault()
    data = $("form.default-term-form").serializeObject();
#    if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.name #默认搜索词名称
#      that.tip $("#termName").parent(),"error", "up", "不能输入特殊字符！"
#      $(".tip").css("left", 180).css("top", 36).css("width", 150)
#      return
    $.ajax
      url: Store.context + "/api/admin/defaultSearchTerm/edit/" + id
      type: "POST"
      data: $("form.default-term-form").serialize()
      success: (data)->
        window.location.reload()
  deleteConfirm: (evt, data)->
    $.ajax
      url: Store.context + "/api/admin/defaultSearchTerm/delete/" + data
      type: "POST"
      success: (data)->
        window.location.href = Store.context + "/admins/default_search_term"


module.exports = defaultSearchTerm
