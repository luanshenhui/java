Store = require "extras/store"

class TipAndAlert
  tipTemplate = App.templates.tip
  alertTemplate = App.templates.alert
  tip: (parent, type, direct, message, width)->
    $(".tip").remove()
    $(parent).addClass("parent-position")
    $(parent).append(tipTemplate({type: type, direct: direct, message: message}))
    if width
      $(".tip").css("width", width)
    _.delay tipOrAlertRemove, 5000, ".tip"
    _.delay parentPositionRevert, 5000, parent
  tipOrAlertRemove= (target)->
    $(target).remove()
  parentPositionRevert= (target)->
    $(target).removeClass("parent-position")

  alert: (parent, type, title, message) ->
    $(".alert").remove()
    $(parent).append(alertTemplate({type: type, title: title, message: message}))
    if parent is "body"
      left = $(window).width() / 2 - $(".alert").width() / 2
      top = $(window).height() / 2 - $(".alert").height() / 2
      $(".alert").css("left", left).css("top", top)
    _.delay tipOrAlertRemove, 3000, ".alert"


module.exports =  TipAndAlert::
