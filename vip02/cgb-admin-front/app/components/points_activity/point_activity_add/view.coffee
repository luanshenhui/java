Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"

class point_activity_add
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  startpicker = new Pikaday({field: $(".js-date-start")[0]});
  endpicker = new Pikaday({field: $(".js-date-end")[0]});
  startpicker = new Pikaday({field: $(".js-date-start1")[0]});
  endpicker = new Pikaday({field: $(".js-date-end1")[0]});
  $(".discount").show()
  $(".change").hide()
  $(".groupBuy").hide()
  constructor: ->
    @activityCreate = ".js-activity-create"
    @bindEvent()
  that = this

  bindEvent: ->
    that = this
    $(".activitys-add").on "click", @activityCreate, @newActivity
    $("input[id='ForDiscount']").on "click",@discountOff
    $("input[id='ForGroup']").on "click",@groupOff
    $("input[id='ForChange']").on "click",@changeOff
  discountOff: ->
    $(".discount").show()
    $(".change").hide()
    $(".groupBuy").hide()
  groupOff: ->
    $(".discount").hide()
    $(".change").hide()
    $(".groupBuy").show()
  changeOff: ->
    $(".discount").hide()
    $(".change").show()
    $(".groupBuy").hide()
  newActivity: =>
    $("form.newPointActivity-form").validator()
    $("form.newPointActivity-form").on "submit", @createActivity
  createActivity: (evt)->
    $("form.newPointActivity-form").validator()
    evt.preventDefault()
    $.ajax
      url: Store.context + "/api/admin/newActivity"
      type: "POST"
      data: $("form.newPointActivity-form").serialize()
      success: (data)->
        window.location.reload()

module.exports = point_activity_add

