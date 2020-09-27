Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"
class group_classify
  _.extend @::, TipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
    @attributeNew = ".js-classify-new"
    @attributeForm = ".classify-form"
    @bindEvent()
  newGroupClassifyTemplate = App.templates["classify_new"]
  that = this

  bindEvent: ->
    that = this
    $(".group_classify").on "click", @attributeNew, @newAttribute
    $(document).on "confirm:delete-groupClassify", @deleteAttribute
  streamFun=_.debounce((()->
    $.ajax
      url: Store.context + "/api/admin/promotion/groupClassifyAdd"
      type: "POST"
      data: $("form.classify-form").serialize()
      success: (data)->
        window.location.reload()

  ), 3000,true)
  newAttribute: ->
    component = new Modal newGroupClassifyTemplate({title:"新建分类"})
    component.show()
    $("form.classify-form").validator isErrorOnParent: true
    $(document).on "submit",".classify-form",that.newConfirm

  newConfirm: (event)->
    event.preventDefault()
    $("form.classify-form").validator
      isErrorOnParent: true
    reg=/^[A-Za-z0-9\u4e00-\u9fa5]+$/
    classifyName=$("form.classify-form").serializeObject().name
    unless new RegExp(reg).test(classifyName)
      that.alert "body", "error", "新建失败", "名称只能为数字，字母，中文字符"
      return
    if classifyName.length >10
      that.alert "body", "error", "新建失败", "类别名称最大只允许十个字符"
      return
    streamFun()

  deleteAttribute: (event, data)->
    event.preventDefault()
    id=data
    $.ajax
      url: Store.context + "/api/admin/promotion/groupClassifyDel"
      type: "POST"
      data:{
        id:id
      }
      success: (data)->
        window.location.reload()
module.exports = group_classify