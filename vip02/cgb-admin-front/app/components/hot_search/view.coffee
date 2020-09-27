Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
tipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"

class hot_search_terms
  _.extend @::, tipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
    @termNew = ".js-terms-new"
    @termEdit = ".js-terms-edit"
    @termForm = ".term-form"
    @termName = ".js-terms-name"
    @bindEvent()
  newTermsTemplate = App.templates["hot_search_new"]
  that = this

  bindEvent: ->
    that = this
    $(document).on "confirm:delete-item", @deleteConfirm
    $(".terms").on "click", @termNew, @newTerm
    $(".terms").on "click", @termEdit, @editTerm

  newTerm: =>
    data = {}
    data.title = "新增热搜词"
    addTemplate = new Modal newTermsTemplate({data:data})
    addTemplate.show()
    $(that.termForm).validator
      isErrorOnParent: true
    $("form.term-form").on "submit", @createTerm

  createTerm: (evt)->
    $("form.term-form").validator()
    evt.preventDefault()
    data = $("form.term-form").serializeObject();

    if !/^[1-9]\d*$/.test data.sort #排序
      that.tip $("#sort").parent(),"error", "up", "请输入正整数！"
      $(".tip").css("left", 180).css("top", 36).css("width", 150)
      return
#    if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.name #热搜词名称
#      that.tip $("#terms_name").parent(),"error", "up", "不能输入特殊字符！"
#      $(".tip").css("left", 180).css("top", 36).css("width", 150)
#      return
    $.ajax
      url: Store.context + "/api/admin/hotSearchTerms/add"
      type: "POST"
      data: $("form.term-form").serialize()
      success: (data)->
        window.location.reload()
  editTerm: ->
    thisItem= $(@).closest("tr").data("data")
    editTemplate = new Modal newTermsTemplate(thisItem)
    editTemplate.show()
    $(that.termForm).validator
      isErrorOnParent: true
    if(thisItem.status == "0")
      $("input[type='checkbox']").prop('checked',"checked")
    $("form.term-form").on "submit", that.editConfirm
  editConfirm: (event)->
    $("form.term-form").validator()
    event.preventDefault()
    data = $("form.term-form").serializeObject();
    $(".sort-required-error").remove()  #排序
    $(".name-required-error").remove()  #热搜词名称

    if !/^[1-9]\d*$/.test data.sort #排序
      that.tip $("#sort").parent(),"error", "up", "请输入正整数！"
      $(".tip").css("left", 180).css("top", 36).css("width", 150)
      return
#    if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.name #热搜词名称
#      that.tip $("#terms_name").parent(),"error", "up", "不能输入特殊字符！"
#      $(".tip").css("left", 180).css("top", 36).css("width", 150)
#      return
    $.ajax
      url: Store.context + "/api/admin/hotSearchTerms/edit/"+$("#terms_name").data("name")
      type: "POST"
      data: $("form.term-form").serialize()
      success: (data)->
        window.location.reload()
  deleteConfirm: (evt, data)->
    $.ajax
      url: Store.context + "/api/admin/hotSearchTerms/delete"
      type: "POST"
      data:{"name":data}
      success: (data)->
        if $(".pagination").data("total") % 20 == 1
          window.location.href = Store.context + "/admins/hot_search"
        else
          window.location.reload()
module.exports = hot_search_terms