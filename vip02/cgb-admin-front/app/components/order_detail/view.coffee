Modal = require "spirit/components/modal"
Store = require "extras/store"

class orderDetail
  constructor: ->
    @orderReturn = ".js-return"
    @orderPass = ".js-pass"
    @orderRefuse = ".js-refuse"
    @bindEvent()
  that = this

  bindEvent: ->
    that = this
    $(".order-etm").on "click", @orderReturn, @returnNew
    $(".order-etm").on "click", @orderPass, @returnNew
    $(".order-etm").on "click", @orderRefuse, @returnNew
  returnNew: ->
    window.location.href = Store.context + "/mall/request_money"
module.exports = orderDetail
