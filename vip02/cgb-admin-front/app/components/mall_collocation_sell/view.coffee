Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"

class collocationSellMall
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
    @collocationEdit = ".js-item-edit"

    @bindEvent()
  newCollocationTemplate = App.templates["collocation_sell_new"]
  that = this

  bindEvent: ->
    that = this
    $(document).on "click", @collocationEdit, @editCollocation
    $(document).on "confirm:delete-item", @deleteConfirm

  editCollocation: ->
    data = $(@).closest("tr").data("data")
    component = new Modal(newCollocationTemplate(data)).show()
    $(".collocation-form").validator()

  deleteConfirm: (evt, data)->
    $.ajax
      url: "/api/order/" + data
      type: "DELETE"
      success: (data)->
        window.location.reload()

module.exports = collocationSellMall

