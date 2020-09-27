tipAndAlert = require "tip_and_alert/tip_and_alert"
Modal = require "spirit/components/modal"
Store = require "extras/store"

passwordModifyTemplate = App.templates["password_modify_manager"]

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
    passwordObj = document.getElementById("login-password");
    if passwordObj.GetPL() is 0
      that.tip $("#login-password").parent(), "error", "up", "密码不能为空！"
      $(".tip").css({"margin-left": "30px", "margin-top": "44px", "z-index": 999})
      status = true
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
    passwordObj = document.getElementById("login-password");
    password = ''
    version = passwordObj.GetV()
    versionArr = version.split('.')
    if versionArr[1] == '3' or versionArr[1] == '4' or versionArr[1] == '5'
      #6位随机数
      randomPwd = getRandomCode()
      password = passwordObj.GetRT2048(randomPwd)
    else
      password = passwordObj.GetRT()
    password = password.substring(0, password.length - 4)
    json = $("#login").serializeObject()
    target = window.location.search
    if "" isnt target
      target = target.substring(8, target.length)
    json.target = target
    json.password = password
    $.ajax
      url: Store.context + "/api/admin/user/login"
      type: "POST"
      data: json
      success: (data)->
        $("body").spin(false)
        if data.data.isUpPwd
          new Modal(passwordModifyTemplate({title: "首次登录修改密码"})).show()
          $(".modal-modify-password").css({"top": "50px", "left": "120px"})
          $(that.modifyPasswordForm).validator
            isErrorOnParent: true
          $(that.modifyPasswordForm).on "submit", ->
            firstPasswordObj = document.getElementById("password-first")
            secondPasswordObj = document.getElementById("password-second")
            newPasswordObj = document.getElementById("new-password")
            cfrmPasswordObj = document.getElementById("cfrm-password")
            if firstPasswordObj.GetPL() is 0
              that.tip $("#password-first-div").parent(), "error", "up", "一次密码不能为空！"
              $(".tip").css({"margin-left": "354px", "margin-top": "-10px", "z-index": 999})
              return
            if secondPasswordObj.GetPL() is 0
              that.tip $("#password-second-div").parent(), "error", "up", "二次密码不能为空！"
              $(".tip").css({"margin-left": "354px", "margin-top": "-10px", "z-index": 999})
              return
            if newPasswordObj.GetPL() is 0
              that.tip $("#new-password-div").parent(), "error", "up", "新密码不能为空！"
              $(".tip").css({"margin-left": "354px", "margin-top": "-10px", "z-index": 999})
              return
            if cfrmPasswordObj.GetPL() is 0
              that.tip $("#cfrm-password-div").parent(), "error", "up", "确认密码不能为空！"
              $(".tip").css({"margin-left": "354px", "margin-top": "-10px", "z-index": 999})
              return
            checkMsg = checkPwdObject2(newPasswordObj, '新密码', cfrmPasswordObj, '密码确认', '222', '8-12位', null)
            if "" isnt checkMsg
              that.alert "body", "error", "提示！", checkMsg
              $(".alert").css("z-index", 999)
              return

            newPassword = ''
            firstPassword = ''
            secondPassword = ''
            version = newPasswordObj.GetV()
            versionArr = version.split('.')
            if versionArr[1] == '3' or versionArr[1] == '4' or versionArr[1] == '5'
              randomPwd = getRandomCode()
              #6位随机数
              firstPassword = firstPasswordObj.GetRT2048(randomPwd)
              secondPassword = secondPasswordObj.GetRT2048(randomPwd)
              newPassword = newPasswordObj.GetRT2048(randomPwd)
            else
              firstPassword = firstPasswordObj.GetRT()
              secondPassword = secondPasswordObj.GetRT()
              newPassword = newPasswordObj.GetRT()
            form = $(that.modifyPasswordForm).serializeObject()
            form.passwordNew = newPassword.substring(0, newPassword.length - 4)
            form.passwordFirst = firstPassword.substring(0, firstPassword.length - 4)
            form.passwordSecond = secondPassword.substring(0, secondPassword.length - 4)
            form.userName = json.userName
            $.ajax
              url: Store.context + "/api/admin/user/modifyManagerPwd"
              type: "POST"
              data: form
              success: (ret)->
                that.alert "body", "icons-true", "提示！", "修改密码成功"
                $(".alert").css("z-index", 999)
                window.location.href = Store.context + "/index"
                window.event.returnValue = false
              error: (ret)->
                that.alert "body", "error", "出错啦！", ret.responseText
                $(".alert").css("z-index", 999)
        else
          window.location.href = decodeURIComponent(data.data.url)
      error: (data)->
        $("body").spin(false)
        $("#code").val("")
        $(".login-btn-admin").attr("disabled",false)
        that.alert "body", "error", data.responseText
        that.initCaptcha()


module.exports = Login
