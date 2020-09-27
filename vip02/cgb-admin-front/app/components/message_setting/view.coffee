Modal = require "spirit/components/modal"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"

class messageSetting
  _.extend @::, TipAndAlert

  constructor: ->
    @switchEdit = ".js-switch-edit"
    @jsFileUpload = ".js-image-upload"
    @bindEvent()
  sitesTemplate = App.templates.sites_config_detail
  that = this
  bindEvent: ->
    that = this
    $(@switchEdit).on "click", @updateSwitch
    @uploadFile()

  uploadFile: ->
    $(that.jsFileUpload).fileupload
      url: "/api/images/upload"
      dataType: "json"
      start: ->
      done: (e, result) =>
      fail: (evt, data) ->
        jqXHR = data.jqXHR
        content = if jqXHR.status is 413
          "上传的文件超过规定大小"
        else
          jqXHR.responseText
        new Modal(
          icon: "error"
          title: "您的当前状态:"
          content: content
          overlay: false
        ).show()
      error:(data)->
        responseText = ""
        if data.status is 413 then responseText = "上传的文件超过规定大小" else responseText = data.responseText
        new Modal(
          icon: "error"
          title: "出错啦！"
          content: responseText
          overlay: false)
        .show()
  updateSwitch: (evt)->
    obj = $("form.message-form").serializeObject()
    #商城公告开关ID
    obj.mallId = $("#mallOpen").data("id")
    #短信发送开关ID
    obj.messageId = $("#messageOpen").data("id")
    $.ajax
      url: Store.context + "/api/admin/messageSetting"
      type: "PUT"
      data: obj
      success: (data)->
        that.alert "body", "success", "保存成功！", "请继续其他操作！"
        left = $(window).width() / 2 - $(".alert").width() / 2
        top = $(window).height() / 2 - $(".alert").height() / 2
        $(".alert").css("left", left).css("top", top)

module.exports = messageSetting
