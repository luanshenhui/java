tipAndAlert = require "tip_and_alert/tip_and_alert"
Modal = require "spirit/components/modal"
Store = require "extras/store"

passwordModifyTemplate = App.templates.login.templates["password_modify_manager"]

class Login
  _.extend @::, tipAndAlert

  constructor: ->
    @loginForm = $("#login")
    @userName = $("#loginId")
    @loginType = $("#login-type")
    @jsImgChange = $(".js-img-change")
    @modifyPasswordForm = "form.modify-password-form"
    @closeModifyPwd = ".close-modify-pwd"
    @loginForm.validator()
    @bindEvent()
    @initCaptcha()
  that = this
  bindEvent: ->
    that = this

    @loginForm.on "submit", @validateForm
    @jsImgChange.on "click", @initCaptcha
    $(document).on "click", ".close", @retSubmit

  retSubmit: ->
    $(".login-btn-admin").attr("disabled",false)

  initCaptcha: ->
    url = Store.context + "/api/captcha?" + new Date().getTime()
    $(".login-img").attr("src", url)


  validatorLoginName: ->
    if /1[3|4|5|8][0-9]{9}/.test @userName.val()
      @loginType.val(2)
    else if /\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.test @userName.val()
      @loginType.val(1)
    else if /[\d_a-zA-Z\u4E00-\u9FA5]{5,20}/.test @userName.val()
      @loginType.val(3)

  validateForm: (evt)=>
    evt.preventDefault()
    status = false
    @validatorLoginName()
    for input in $("input")
      if _.isEqual($.trim($(input).val()), "")
        name = $(input).attr("name")
        switch name
          when "userName"
            that.tip $(input).parent(), "error", "up", "用户名不能为空！"
            $(".tip").css("left", 97).css("top", 36)
            status = true
          when "code"
            that.tip $(input).parent(), "error", "up", "验证码不能为空！"
            $(".tip").css("left", 97).css("top", 36)
            status = true
          else
        break
    if status
      return;
    @loginSubmit(evt)

  loginSubmit: (evt) ->
    evt.preventDefault()
    $(".login-btn-admin").attr("disabled",true)
    $("body").spin("big")
    $.ajax
      url: Store.context + "/api/admin/user/login"
      type: "POST"
      data:$(".form.form-user-login").serializeObject()
      success: (data)->
        $("body").spin(false)
        window.location.href = decodeURIComponent(data.data.url)
      error: (data)->
        $("body").spin(false)
        $("#code").val("")
        $(".login-btn-admin").attr("disabled",false)
        that.alert "body", "error", data.responseText
        that.initCaptcha()


module.exports = Login
