zIndex = 10000
dialogTemplate = Handlebars.templates["popup/templates/dialog_template"]

infoBoxTemplate = Handlebars.templates["popup/templates/info_box_template"]

dialog = (content) ->
  $("body").append("""<div class=\"popup-disable-cover\" style=\"height: #{$(document).height()}px;z-index: #{zIndex}\"></div>""")
  $dialog = $("""<div class=\"popup-modal\" style=\"z-index: #{zIndex + 1}\">#{content}</div>""").appendTo("body")
  $dialog.css(
    top: (($(window).height() - $dialog.height()) / 2) + "px"
    left: (($(window).width() - $dialog.width()) / 2) + "px"
  ).show().addClass("show")
  $(".close, .js-btn-cancel, .js-btn-close", $dialog).click ->
    close()
  zIndex = zIndex + 2
  $dialog

show = (config, callback) ->
  if typeof config isnt "object"
    content = config
    config = 
      content: content
  config.type = config.type or "confirm"
  config.callback = config.callback or callback
  $dialog = dialog dialogTemplate(config)
  deferred = $.Deferred()
  $(".js-btn-cancel, .close", $dialog).off("click").click (evt) ->
    $(".ac").hide() if $(".ac")
    evt.stopPropagation()
    $("popup-dialog-content").empty()
    close()
    deferred.reject($dialog)
  $(".js-btn-ok", $dialog).off("click").click ->
    close() unless config.noAutoClose
    deferred.resolve($dialog)
  config.callback?($dialog, deferred)
  deferred.promise()

close = (target) ->
  $("popup-dialog-content").empty()
  if not target or target.is(":visible")
    $(".popup-disable-cover:last").remove()
    $(".popup-modal:last").remove()

    zIndex = zIndex - 2

get = ->
  $(".popup-modal:last")

confirm = (rootStyle, iconStyle, message) ->
  config =
    rootStyle: rootStyle
    title: "确认"
    type: "confirm"
  infoBoxContent =
    iconStyle: iconStyle
  if typeof message == "object"
    infoBoxContent.message = message.message
    config.confirm = message.confirm
    config.cancel = message.cancel
  else
    infoBoxContent.message = message
  config.content = infoBoxTemplate(infoBoxContent)
  show config

alert = (rootStyle, iconStyle, message, autoCloseDelay, noControl) ->
  config =
    rootStyle: rootStyle
    title: if autoCloseDelay and not noControl then "提示 - #{autoCloseDelay}秒后自动关闭" else "提示"
    type: "alert"
    noControl: noControl
  infoBoxContent =
    iconStyle: iconStyle
  if typeof message == "object"
    infoBoxContent.message = message.message
    config.confirm = message.confirm
    config.cancel = message.cancel
  else
    infoBoxContent.message = message
  config.content = infoBoxTemplate(infoBoxContent)
  show config, ($dialog, deferred) ->
    if autoCloseDelay
      setTimeout ->
        close $dialog
        deferred.reject()
      , autoCloseDelay * 1000


module.exports =
  dialog: dialog
  show: show
  close: close
  get: get
  confirm: confirm
  alert: alert
