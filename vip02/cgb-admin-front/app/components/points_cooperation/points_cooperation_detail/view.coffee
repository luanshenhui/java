tipAndAlert = require "tip_and_alert/tip_and_alert"
Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"

class PointsCooperationDetail
  _.extend @::, tipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
    @cooperationDetailForm = "form.cooperation-detail-form"
    @bindEvent()
  that = this

  bindEvent: ->
    that = this
    $("#pass").on "click",@passCooperation
    $("#refuse").on "click",@refuseSubmit
    $("#return").on "click",@returnCooperation

  passCooperation: ()->
    if $(".vfirst").is(":visible") is true
#    密码校验及加密开始
      $(".js-error").remove()
      newPasswordObj = document.getElementById("passwordNew-div")
      cfrmPasswordObj = document.getElementById("passwordConfirm-div")
      if newPasswordObj.GetPL() is 0
        $("#passwordNew").siblings(".note").hide()
        $("#passwordNew").parent().append("<span class=\"note-error js-error\"><i>&times;</i> 二次密码不能为空</span>")
        $("#passwordNew").siblings(".note-error").show()
        return
      checkMsgPwsecond = checkPwdObject1(newPasswordObj, '二次密码', "222", '4位', null)
      if "" isnt checkMsgPwsecond
        $("#passwordNew").siblings(".note").hide()
        $("#passwordNew").parent().append("<span class=\"note-error js-error\"><i>&times;</i> "+"必须包含三种类型的字符"+"</span>")
        $("#passwordNew").siblings(".note-error").show()
        return
      if cfrmPasswordObj.GetPL() is 0
        $("#passwordConfirm").siblings(".note").hide()
        $("#passwordConfirm").parent().append("<span class=\"note-error js-error\"><i>&times;</i> 确认密码不能为空</span>")
        $("#passwordConfirm").siblings(".note-error").show()
        return
      checkMsgPwfirst = checkPwdObject1(cfrmPasswordObj, '确认密码', '222', '4位', null)
      if "" isnt checkMsgPwfirst
        $("#passwordConfirm").siblings(".note").hide()
        $("#passwordConfirm").parent().append("<span class=\"note-error js-error\"><i>&times;</i> "+"必须包含三种类型的字符"+"</span>")
        $("#passwordConfirm").siblings(".note-error").show()
        return
      checkMsg = checkPwdObject2(newPasswordObj, '二次密码', cfrmPasswordObj, '确认密码', '222', '4位', null)
      if "" isnt checkMsg
        $("#passwordConfirm").siblings(".note").hide()
        $("#passwordConfirm").parent().append("<span class=\"note-error js-error\"><i>&times;</i> "+checkMsg+"</span>")
        $("#passwordConfirm").siblings(".note-error").show()
        return
#      $(".js-error").remove()
#      newPasswordObj = document.getElementById("passwordNew-div")
#      cfrmPasswordObj = document.getElementById("passwordConfirm-div")
#      if newPasswordObj.GetPL() is 0
#        that.tip $("#passwordNew").parent(),"error", "up", "请输入数字、大小写字母和特殊字符组合的4位密码！"
#        $(".tip").css("left", 170).css("top", 36).css("width", 350)
#        $("body").scrollTop $(".vfirst").offset().top-20
#        return
#      checkMsgPwsecond = checkPwdObject1(newPasswordObj, '二次密码', "222", '4位', null)
#      if "" isnt checkMsgPwsecond
#        that.tip $("#passwordNew").parent(),"error", "up", checkMsgPwsecond
#        $(".tip").css("left", 170).css("top", 36).css("width", 350)
#        $("body").scrollTop $(".vfirst").offset().top-20
#        return
#      if cfrmPasswordObj.GetPL() is 0
#        that.tip $("#passwordConfirm").parent(),"error", "up", "请输入数字、大小写字母和特殊字符组合的4位密码！"
#        $(".tip").css("left",230).css("top", 36).css("width", 350)
#        $("body").scrollTop $(".vfirst").offset().top-20
#        return
#      checkMsgPwfirst = checkPwdObject1(cfrmPasswordObj, '确认密码', '222', '4位', null)
#      if "" isnt checkMsgPwfirst
#        that.tip $("#passwordConfirm").parent(),"error", "up", checkMsgPwfirst
#        $(".tip").css("left", 230).css("top", 36).css("width", 350)
#        $("body").scrollTop $(".vfirst").offset().top-20
#        return
#      checkMsg = checkPwdObject2(newPasswordObj, '二次密码', cfrmPasswordObj, '确认密码', '222', '4位', null)
#      if "" isnt checkMsg
#        that.tip $("#passwordConfirm").parent(),"error", "up", checkMsg
#        $(".tip").css("left", 230).css("top", 36).css("width", 350)
#        $("body").scrollTop $(".vfirst").offset().top-20
#        return


      newPassword = ''
      version = newPasswordObj.GetV()
      versionArr = version.split('.')
      if versionArr[1] == '3' or versionArr[1] == '4' or versionArr[1] == '5'
        randomPwd = getRandomCode()
        #6位随机数
        newPassword = newPasswordObj.GetRT2048(randomPwd)
      else
        newPassword = newPasswordObj.GetRT()

      password = newPassword.substring(0, newPassword.length - 4)


    $.ajax
      url: Store.context + "/api/admin/cooperation/audit"
      type: "POST"
      data: {
        vendorId: $("#vendorId").data("id"),
        pwsecond: password,
        refuseDesc: $("#refuseDesc").val(),
        status: $("#status").val(),
        vendorStatus: $("#vendorStatus").val()
      }
      success: (data)->
        window.location.href= Store.context + "/points/cooperation/cooperation_all"
  refuseSubmit:->
    if $("#refuseDesc").val() is ""
      that.tip $("#refuseDesc").parents("p").find("label"), "error", "up", "请填写审核意见！"
      $(".tip").css("top", 36).css("width", 150)
#      that.alert "body", "error", "请填写审核意见！"
      return
#    else
#      if /[~'!@#$%&*()-+_=:]/.test $("#refuseDesc").val()
#        that.alert "body", "error", "审核意见不允许输入特殊字符！"
#        return
    $.ajax
      url: Store.context + "/api/admin/cooperation/audit-vendorRefuse"
      type: "POST"
      data: {
        vendorId: $("#vendorId").data("id"),
        refuseDesc: $("#refuseDesc").val()
      }
      success: (data)->
        window.location.href= Store.context + "/points/cooperation/cooperation_all";

  returnCooperation:->
    window.location.href=Store.context + "/points/cooperation/cooperation_all";


module.exports = PointsCooperationDetail
