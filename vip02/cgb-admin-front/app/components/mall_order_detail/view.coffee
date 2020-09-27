Modal = require "spirit/components/modal"
Store = require "extras/store"

class mallOrderDetail
  constructor: ->
    @bindEvent()
    @checkLastChild()
  that = this

  bindEvent: ->
    that = this
  checkLastChild: ->
    $(".js-check-lastChild li:last-child").css("position","relative")
    $(".js-check-lastChild li:last-child").append('<span class="afterLine">' + '</span>')

module.exports = mallOrderDetail
