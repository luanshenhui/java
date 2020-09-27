Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
dicAddTemplate = App.templates.dic_add
dicItemAddTemplate = App.templates.dic_item_add
Store = require "extras/store"
class Dic
  constructor: ->
    @jsDictionaryNew = $(".js-dictionary-new")
    @jsItemAdd = $(".js-item-add")
    @jsDicItemDel = $(".js-dic-item-del")
    @dicForm = ".dic-form"
    @bindEvent()

  that = this
  bindEvent: ->
    that = this
    @jsDictionaryNew.on "click", @addDic


  addDic: ->
    new Modal(dicAddTemplate({})).show()
    $(".js-item-add").on "click", that.addItem
    $(".js-dic-item-del").on "click", that.deleteItem
    $("form.dic-form").on "submit", that.createDic

  addItem: ->
    $(".dic-item").append(dicItemAddTemplate({}));

  deleteItem: ->
    $(that).closest(".dic-item-sub").remove()

  createDic: (evt)->
    evt.preventDefault()
    $(that.dicForm).validator
      isErrorOnParent: true
    data = $("form.dic-form").serializeObject()
    data.items = []
    $(".dic-item-sub").each ->
      item = {}
      item.code = $(@).find(".item-key").val()
      item.text = $(@).find(".item-value").val()
      data.items.push item
    $.ajax
      url: Store.context + "/api/admin/dictionary"
      method: "post"
      data: {dic: JSON.stringify data}
      success: ->
        location.reload()
      error: ->


module.exports = Dic