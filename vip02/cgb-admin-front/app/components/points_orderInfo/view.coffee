Modal = require "spirit/components/modal"
Store = require "extras/store"

class pointsOrderInfo
  constructor: ->
    @checkLastChild()
    @bindEvent()
  that = this

  bindEvent: ->
    that = this
  checkLastChild: ->
    $(".js-check-lastChild li:last-child").css("position","relative")
    $(".js-check-lastChild li:last-child").append('<span class="afterLine">' + '</span>')
module.exports = pointsOrderInfo
