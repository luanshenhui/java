Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"
class point_activity
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  startpicker = new Pikaday({field: $(".js-date-start")[0]});
  endpicker = new Pikaday({field: $(".js-date-end")[0]});
  $("#endDiv").hide()
  constructor: ->
    @requestAll = ".js-tab1"
    @requestTodo = ".js-tab2"
    @requestDo = ".js-tab3"
    @requestDone = ".js-tab4"
    @bindEvent()
  that = this
  bindEvent: ->
    that = this
    $(".tabfor").on "click", @requestAll, @divHide
    $(".tabfor").on "click", @requestTodo, @divShow
    $(".tabfor").on "click", @requestDo, @divHide
    $(".tabfor").on "click", @requestDone, @divHide
  divShow: =>
    $("#endDiv").show()
  divHide: =>
    $("#endDiv").hide()

module.exports = point_activity

