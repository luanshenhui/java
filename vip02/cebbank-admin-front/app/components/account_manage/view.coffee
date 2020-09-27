Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
tipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"

accountNewTemplate = App.templates.account_manage.templates["account_add"]
accountAssignTemplate = App.templates.account_manage.templates["account_assign_role"]
checkAccountTemplate = App.templates.account_manage.templates["check_account"]
passwordEditTemplate = App.templates.account_manage.templates["password_edit"]
accountViewTemplate = App.templates.account_manage.templates["account_view"]
passWordTemplate = App.templates.account_manage.templates["password"]

class accountManage
  _.extend @::, tipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
    @accountNew = ".js-account-new"
    @accountAssign = ".js-account-assign"
    @accountUpdate = ".js-account-update"
    @accountView = ".js-account-view"
    @accountDisabled = ".js-account-disabled"
    @accountForm = "form.account-form"
    @accountAssignForm = "form.accountAssign-form"
    @accountCheckForm = "form.check-form"
    @accountId = "#account"
    @$jsCheck = $(".js-check-status")
    @$checkRefuse = "#checkRefuse"
    @$checkStatus = "#checkStatus"
    @$jsStatus0 = $(".js-status0")
    @$jsStatus1 = $(".js-status1")
    @confirmPassInput = "#confirmPsw"
    @pwsecondInput ="#pwfirst"
    @passwordInput= $("#password")
    @$jsPasswordEdit = $(".js-password-edit")
    @editPasswordForm = "form.edit-password-form"
    @jsPasswordConfirm = ".js-passwordConfirm"
    @jsEmail = "#email"
    @jsPhone = "#phone"
    @jsFax = "#fax"

    @bindEvent()
  that = this
  bindEvent: ->
    that = this
    $(@accountNew).on "click", @newAccount
    $(@accountAssign).on "click", @assignAccount
    $(@accountUpdate).on "click", @editAccount
    $(@accountDisabled).on "click", @disabledAccount
    @$jsCheck.on "click", @authCheck
    $(document).on "click", @$checkRefuse, @checkRefuse
    $(document).on "click", @$checkStatus, @checkStatuss
    $(document).on "confirm:js-status0", @statusChange0
    $(document).on "confirm:js-status1", @statusChange1
    $(document).on "confirm:delete-account", @deleteAccount
    @$jsPasswordEdit.on "click", @passwordEdit
    $(@accountView).on "click", @viewAccount
    $(document).on "blur", @confirmPassInput, @confirmPassword
    $(document).on "blur", @pwsecondInput, @confirmPassword
    $(document).on "blur", @jsPasswordConfirm, @confirmPasswordTwo
    $(document).on "blur", @jsEmail, @email1
    $(document).on "focus", @jsEmail, @email2
    $(document).on "blur", @jsPhone, @phone1
    $(document).on "focus", @jsPhone, @phone2
    $(document).on "blur", @jsFax, @fax1
    $(document).on "focus", @jsFax, @fax2

  fax1:->
    fax = $("#fax").val()
    if fax!=''
      if !/^[+]{0,1}(\d){1,3}[ ]?([-]?((\d)|[ ]){1,12})+$/.test fax
        $("#fax").parent().append("<span class=\"mail-required-error js-fax required\"><i>&times;</i>传真格式不正确</span>")
        return
  fax2:->
    $(".js-fax").remove()
  phone1:->
    phone = $("#phone").val()
    if phone!=''
      if !/0\d{2,3}-\d{5,9}|0\d{2,3}-\d{5,9}/.test phone
        $("#phone").parent().append("<span class=\"mail-required-error js-phone required\"><i>&times;</i>座机号格式不正确</span>")
        return
  phone2:->
    $(".js-phone").remove()
  email2:->
    $(".js-email").remove()

  email1:->
    email = $("#email").val()
    if email!=''
      if !/\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.test email   #电子信箱
        $("#email").parent().append("<span class=\"mail-required-error js-email required\"><i>&times;</i>邮箱格式不正确</span>")
        return
  passwordEdit: ->
    new Modal(passwordEditTemplate({title: "账号密码修改",id: $(@).closest("tr").data("id")})).show()
    $(that.editPasswordForm).validator
      isErrorOnParent: true
    $(that.editPasswordForm).on "submit", that.updataPassWordSubmit

  updataPassWordSubmit: ->
    $(".js-error").remove()
    newPasswordObj = document.getElementById("passwordNew-div")
    cfrmPasswordObj = document.getElementById("passwordConfirm-div")
    if newPasswordObj.GetPL() is 0
      $("#passwordNew").siblings(".note").hide()
      $("#passwordNew").parent().append("<span class=\"note-error js-error\"><i>&times;</i> 一次密码不能为空</span>")
      $("#passwordNew").siblings(".note-error").show()
      return
    checkMsgPwsecond = checkPwdObject1(newPasswordObj, '一次密码', "222", '4位', null)
    if "" isnt checkMsgPwsecond
      $("#passwordNew").siblings(".note").hide()
      $("#passwordNew").parent().append("<span class=\"note-error js-error\"><i>&times;</i> "+"4位且包含三种类型的字符"+"</span>")
      $("#passwordNew").siblings(".note-error").show()
      return
    if cfrmPasswordObj.GetPL() is 0
      $("#passwordConfirm").siblings(".note").hide()
      $("#passwordConfirm").parent().append("<span class=\"note-error js-error\"><i>&times;</i> 确认密码不能为空</span>")
      $("#passwordConfirm").siblings(".note-error").show()
      return
    checkMsgPwfirst = checkPwdObject1(cfrmPasswordObj, '确认密码',  '222', '4位', null)
    if "" isnt checkMsgPwfirst
      $("#passwordConfirm").siblings(".note").hide()
      $("#passwordConfirm").parent().append("<span class=\"note-error js-error\"><i>&times;</i> "+"4位且包含三种类型的字符"+"</span>")
      $("#passwordConfirm").siblings(".note-error").show()
      return
    checkMsg = checkPwdObject2(newPasswordObj, '一次密码', cfrmPasswordObj, '确认密码', '222', '4位', null)
    if "" isnt checkMsg
      $("#passwordConfirm").siblings(".note").hide()
      $("#passwordConfirm").parent().append("<span class=\"note-error js-error\"><i>&times;</i> "+checkMsg+"</span>")
      $("#passwordConfirm").siblings(".note-error").show()
      return

    newPassword = ''
    version = newPasswordObj.GetV()
    versionArr = version.split('.')
    if versionArr[1] == '3' or versionArr[1] == '4' or versionArr[1] == '5'
      randomPwd = getRandomCode()
      #6位随机数
      newPassword = newPasswordObj.GetRT2048(randomPwd)
    else
      newPassword = newPasswordObj.GetRT()
    newPassword = newPassword.substring(0, newPassword.length - 4)

    data = $(that.editPasswordForm).serializeObject()
    data.userId = $(that.editPasswordForm).data("account-id")
    data.id = $(that.editPasswordForm).data("account-id")
    data.pwfirst = newPassword
    data.checkStatus = 0
    $.ajax
      url: Store.context + "/api/admin/user/updatePassWord"
      type: "POST"
      data: data
      success: ->
        window.location.reload()

  checkRefuse: ->
    $('js-show-hide').removeAttr("required");
    $(".js-show-hide").hide()
    $(".js-password1").val("1qAz")
    $(".js-password2").val("1qAz")
    $(".js-descript").val("")

  checkStatuss:->
    $(".js-show-hide").show()
    $(".js-descript").val("")
    $(".js-password1").val("")
    $(".js-password2").val("")

  statusChange0:(evt,id) ->
    data = $("form.check-form").serializeObject()
    data.status = 1
    $.ajax
      url: Store.context + "/api/admin/user/startStop/#{id}"
      type: "POST"
      data: data
      success: ->
        window.location.reload()

  statusChange1:(evt,id) ->
    roles = $("#"+id).data("role")
    if roles is undefined or roles is null or roles is ''
      tipAndAlert.alert "body", "error", "请先分配角色再启用"
      return
    data = $("form.check-form").serializeObject()
    id = id
    data.status = 0
    $.ajax
      url: Store.context + "/api/admin/user/startStop/#{id}"
      type: "POST"
      data: data
      success: ->
        window.location.reload()

  authCheck: ->
    new Modal(checkAccountTemplate({account: $(@).closest("tr").data("id")})).show()
    $(that.accountCheckForm).validator
      isErrorOnParent: true
    $(that.accountCheckForm).on "submit", that.checkStatusSubmit

  checkStatusSubmit: ->
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
      $("#passwordNew").parent().append("<span class=\"note-error js-error\"><i>&times;</i> "+"4位且包含三种类型的字符"+"</span>")
      $("#passwordNew").siblings(".note-error").show()
      return
    if cfrmPasswordObj.GetPL() is 0
      $("#passwordConfirm").siblings(".note").hide()
      $("#passwordConfirm").parent().append("<span class=\"note-error js-error\"><i>&times;</i> 确认密码不能为空</span>")
      $("#passwordConfirm").siblings(".note-error").show()
      return
    checkMsgPwfirst = checkPwdObject1(cfrmPasswordObj, '确认密码',  '222', '4位', null)
    if "" isnt checkMsgPwfirst
      $("#passwordConfirm").siblings(".note").hide()
      $("#passwordConfirm").parent().append("<span class=\"note-error js-error\"><i>&times;</i> "+"4位且包含三种类型的字符"+"</span>")
      $("#passwordConfirm").siblings(".note-error").show()
      return
    checkMsg = checkPwdObject2(newPasswordObj, '一次密码', cfrmPasswordObj, '确认密码', '222', '4位', null)
    if "" isnt checkMsg
      $("#passwordConfirm").siblings(".note").hide()
      $("#passwordConfirm").parent().append("<span class=\"note-error js-error\"><i>&times;</i> "+checkMsg+"</span>")
      $("#passwordConfirm").siblings(".note-error").show()
      return

    newPassword = ''
    version = newPasswordObj.GetV()
    versionArr = version.split('.')
    if versionArr[1] == '3' or versionArr[1] == '4' or versionArr[1] == '5'
      randomPwd = getRandomCode()
      #6位随机数
      newPassword = newPasswordObj.GetRT2048(randomPwd)
    else
      newPassword = newPasswordObj.GetRT()
    newPassword = newPassword.substring(0, newPassword.length - 4)
    data = $("form.check-form").serializeObject()
    data.id = $(that.accountCheckForm).data("account-id")
    data.pwsecond = newPassword
#    password = $("#pwsecond").val()
#    confirmPassword = $("#confirmPsw").val()
#    if password isnt confirmPassword
#      return
#    else
    $.ajax
      url: Store.context + "/api/admin/user/audit/#{data.id}"
      type: "POST"
      data: data
      success: ->
        window.location.reload()


  confirmPassword: ->
    password = $("#pwsecond").val()
    confirmPassword = $(@).val()
    closestGroup = $(@).closest(".control-group")
    closestGroup.find(".note-error").remove()
    closestGroup.find(".note").show()
    if password isnt confirmPassword
      that.isChecked = 0
      $(@).siblings(".note").hide()
      $(@).parent().append("<span class=\"note-error\"><i>&times;</i> 两次密码不相同</span>")
      $(@).siblings(".note-error").show()
    else
      that.isChecked = 1

  confirmPasswordTwo: ->
    password = $("#passwordNew").val()
    confirmPassword = $(@).val()
    closestGroup = $(@).closest(".control-group")
    closestGroup.find(".note-error").remove()
    closestGroup.find(".note").show()
    if password isnt confirmPassword
      that.isChecked = 0
      $(@).siblings(".note").hide()
      $(@).parent().append("<span class=\"note-error\"><i>&times;</i> 两次密码不相同</span>")
      $(@).siblings(".note-error").show()
    else
      that.isChecked = 1

  passwordKeyUp: ->
    pass = $(@).val()
    lv = -1
    lv++ if pass.match(/[a-z]/)
    lv++ if pass.match(/[0-9]/)
    lv++ if pass.match(/[A-Z]/)
    lv++ if pass.match(/[!,@#$%^&*?_~]/)
    lv++ if pass.length > 10 and pass.length <= 16
    lv = -1 if pass.length < 6 or pass.length > 16

  newAccount: ->
    new Modal(accountNewTemplate({title: "添加账户",add:true, code: ""})).show()
    $(that.accountForm).validator
      isErrorOnParent: true
    #    add by liuhan
    $.ajax
      async:false #同步
      url: Store.context + "/api/admin/org/findAll"
      type: "GET"
      success: (data)->
        $.each data.data, (index, item) ->
          values = item.code
          names = item.simpleName
          $(".selectOP").after('<option value='+values+'>'+names+'</option>')
    $(that.accountForm).on "submit", that.createAccount

  createAccount: (evt)->
    evt.preventDefault()
    descript = $("#descript").val().length
    if descript>100
      $(".descript-required-error").remove()
      $("#descript").parent().append("<span class=\"descript-required-error required\"><i>&times;</i>长度不能大于100个字符</span>")
      return
    email = $("#email").val()
    phone = $("#phone").val()
    fax = $("#fax").val()
    if fax!=''
      $(".fax-required-error").remove()
      if !/^[+]{0,1}(\d){1,3}[ ]?([-]?((\d)|[ ]){1,12})+$/.test fax
        $("#fax").parent().append("<span class=\"fax-required-error required\"><i>&times;</i>传真格式不正确</span>")
        return
    if email!=''
      $(".mail-required-error").remove()
      if !/\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.test email   #电子信箱
        $("#email").parent().append("<span class=\"mail-required-error required\"><i>&times;</i> 邮箱格式不正确</span>")
        return

    if phone!=''
      $(".phone-required-error").remove()
      if !/0\d{2,3}-\d{5,9}|0\d{2,3}-\d{5,9}/.test phone
        $("#phone").parent().append("<span class=\"phone-required-error required\"><i>&times;</i> 座机号格式不正确</span>")
        return

    $(".js-error").remove()
    newPasswordObj = document.getElementById("pwsecond-div")
    cfrmPasswordObj = document.getElementById("pwfirst-div")
    if newPasswordObj.GetPL() is 0
      $("#pwsecond").siblings(".note").hide()
      $("#pwsecond").parent().append("<span class=\"note-error js-error\"><i>&times;</i> 一次密码不能为空</span>")
      $("#pwsecond").siblings(".note-error").show()
      return
    checkMsgPwsecond = checkPwdObject1(newPasswordObj, '一次密码', "222", '4位', null)
    if "" isnt checkMsgPwsecond
      $("#pwsecond").siblings(".note").hide()
      $("#pwsecond").parent().append("<span class=\"note-error js-error\"><i>&times;</i> "+"4位且包含三种类型的字符"+"</span>")
      $("#pwsecond").siblings(".note-error").show()
      return
    if cfrmPasswordObj.GetPL() is 0
      $("#pwfirst").siblings(".note").hide()
      $("#pwfirst").parent().append("<span class=\"note-error js-error\"><i>&times;</i> 确认密码不能为空</span>")
      $("#pwfirst").siblings(".note-error").show()
      return
    checkMsgPwfirst = checkPwdObject1(cfrmPasswordObj, '确认密码', '222', '4位', null)
    if "" isnt checkMsgPwfirst
      $("#pwfirst").siblings(".note").hide()
      $("#pwfirst").parent().append("<span class=\"note-error js-error\"><i>&times;</i> "+"4位且必须包含三种类型的字符"+"</span>")
      $("#pwfirst").siblings(".note-error").show()
      return
    checkMsg = checkPwdObject2(newPasswordObj, '一次密码', cfrmPasswordObj, '确认密码', '222', '4位', null)
    if "" isnt checkMsg
      $("#pwfirst").siblings(".note").hide()
      $("#pwfirst").parent().append("<span class=\"note-error js-error\"><i>&times;</i> "+checkMsg+"</span>")
      $("#pwfirst").siblings(".note-error").show()
      return

    newPassword = ''
    version = newPasswordObj.GetV()
    versionArr = version.split('.')
    if versionArr[1] == '3' or versionArr[1] == '4' or versionArr[1] == '5'
      randomPwd = getRandomCode()
      #6位随机数
      newPassword = newPasswordObj.GetRT2048(randomPwd)
    else
      newPassword = newPasswordObj.GetRT()
    newPassword = newPassword.substring(0, newPassword.length - 4)
    data = $(that.accountForm).serializeObject()
    data.pwfirst = newPassword

    $.ajax
      url: Store.context + "/api/admin/user/add"
      type: "POST"
      data: data
      success: (data)->
        if data.data == '98'
          that.alert "body", "error", "新增失败", "用户名被使用过"
          $(".alert").css("z-index":9999)
        else
          if data.data == '99'
            that.alert "body", "error", "新增失败", "登录账号已存在"
            $(".alert").css("z-index":9999)
          else
            window.location.reload()

  assignAccount: (evt)->
    acountId = $(@).closest("tr").data("id")
    #分配角色时，需要从数据库抓取所有角色的列表
    enabledRoles = null
    alreadyCheck = $(@).closest("tr").data("roles")
    alreadyCheckId = _.map(alreadyCheck, (item)->
      return item.roleId
    )
    $.ajax
      async: false
      url: Store.context + "/api/admin/role/allEnabledRoleDtos"
      type: "GET"
      dataType: "JSON"
      success: (data)->
        enabledRoles = data.data
    new Modal(accountAssignTemplate(
      {
        accountId: acountId
        roles: enabledRoles
      }
    )).show()
    $(".accountAssign-form").find("input[type=checkbox][value=" + 3 + "]")
    #选中当前已存在的角色
    for item in alreadyCheckId
      $(".accountAssign-form").find("input[type=checkbox][value=" + item + "]").attr("checked", true)
    $(that.accountAssignForm).on "submit", that.assignAccountImpl

  assignAccountImpl: (event)->
    event.preventDefault()
    accountId = $(that.accountAssignForm).data("accountid")
    #获取所有checkbox的值
    roles = []
    $.each($(that.accountAssignForm).find("[type=checkbox]:checked"), (index, item)->
      roles.push($(item).val())
    )

    tranferObj = {}
    tranferObj.roles=roles
    tranferObj.userId = accountId
    $.ajax
      url: Store.context + "/api/admin/userInfo/assignRole"
      type: "POST"
      contentType: "application/json"
      data: JSON.stringify(tranferObj)
      success: (data)->
        window.location.reload()

  editAccount: ->
    data = $(@).closest("tr").data("data")
    new Modal(accountNewTemplate({
      title: "编辑账户",
      data: data
    })).show()
    $(that.accountForm).validator
      isErrorOnParent: true
    $(that.accountForm).on "submit", that.updateAccount

  updateAccount: (evt)->
    evt.preventDefault()
    descript = $("#descript").val().length
    if descript>100
      $(".js-descript").remove()
      $("#descript").parent().append("<span class=\"mail-required-error js-descript required\"><i>&times;</i>长度不能大于100个字符</span>")
      return
    email = $("#email").val()
    phone = $("#phone").val()
    fax = $("#fax").val()
    if fax!=''
      $(".fax-required-error").remove()
      if !/^[+]{0,1}(\d){1,3}[ ]?([-]?((\d)|[ ]){1,12})+$/.test fax
        $("#fax").parent().append("<span class=\"fax-required-error required\"><i>&times;</i>传真格式不正确</span>")
        return
    if email!=''
      $(".mail-required-error").remove()
      if !/\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.test email   #电子信箱
        $("#email").parent().append("<span class=\"mail-required-error required\"><i>&times;</i> 邮箱格式不正确</span>")
        return

    if phone!=''
      $(".phone-required-error").remove()
      if !/0\d{2,3}-\d{5,9}|0\d{2,3}-\d{5,9}/.test phone
        $("#phone").parent().append("<span class=\"phone-required-error required\"><i>&times;</i> 座机号格式不正确</span>")
        return
    data = $(that.accountForm).serializeObject()
    data.id = $(that.accountForm).data("account-id")
    data.checkStatus = 0
    $.ajax
      url: Store.context + "/api/admin/user/edit/#{data.id}"
      type: "POST"
      data: data
      success: (data)->
        window.location.reload()
      error: (data)->
        window.location.reload()

  disabledAccount: ->
    account = $(@).closest("tr").data("data")
    $.ajax
      url: Store.context + "/api/admin/accounts/setStatus"
      type: "PUT"
      data: account
      success: (data)->
        window.location.reload()
      error: (data)->
        window.location.reload()

  deleteAccount: (evt,data)->
    id = data
    $.ajax
      url: Store.context + "/api/admin/user/delete/#{id}"
      type: "POST"
      data:
        delFlag : 1
      success: (data)->
        window.location.reload()
      error: (data)->
        window.location.reload()

  viewAccount:(evt, data) ->
    data = $(@).closest("tr").data("data")
    new Modal(accountViewTemplate({title: "查看账号",data: data})).show()
module.exports = accountManage
