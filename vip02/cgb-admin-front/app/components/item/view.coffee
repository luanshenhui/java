Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"
class item
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
    @itemNew = ".js-item-new"
    @itemCreate = ".js-item-create"
    @itemEdit = ".js-item-edit"
    @bindEvent()
  newItemTemplate = App.templates["item_new"]
  that = this

  bindEvent: ->
    that = this
    $(".items").on "click", @itemNew, @newItem
    $(".items").on "click", @itemEdit, @editItem
    $(document).on "confirm:delete-item", @deleteConfirm

  newItem: =>
    component = new Modal(newItemTemplate({})).show()
    $("form.item-form").validator()
    $("form.item-form").on "submit", @createItem

  createItem: (evt)->
    $("form.item-form").validator()
    evt.preventDefault()
    $.ajax
      url: "/aip/item"
      type: "POST"
      data: $("form.item-form").serialize()
      success: (data)->
        window.location.reload()

  editItem: ->
    data = $(@).closest("tr").data("data")
    item = new Modal(newItemTemplate(data)).show()
    $("form.item-form").validator()
    $("form.item-form").on "submit", that.editConfirm

  editConfirm: (event)->
    $("form.item-form").validator();
    event.preventDefault()
    $.ajax
      url: "/aip/item"
      type: "PUT"
      data: $("form.item-form").serialize()
      success: (data)->
        window.location.reload()

  deleteConfirm: (evt, data)->
    $.ajax
      url: "/aip/item/" + data
      type: "DELETE"
      success: (data)->
        window.location.reload()




module.exports = item

