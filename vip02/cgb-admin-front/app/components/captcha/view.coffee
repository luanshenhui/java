Modal = require "spirit/components/modal"
Store = require "extras/store"
class captcha
  constructor: ->
    @bindEvent()

  bindEvent: ->
    that = this
    $("#changeImg").on "click", @change

  change: ->
#    date = new Date()
    $("#captchaImg").attr("src",Store.context + "/api/admin/captcha?"+Math.floor(Math.random()*1234))
module.exports = captcha