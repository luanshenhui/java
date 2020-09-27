tipAndAlert = require "tip_and_alert/tip_and_alert"
Modal = require "spirit/components/modal"
Store = require "extras/store"

class PointsCooperationAdd
  _.extend @::, tipAndAlert
  constructor: ->
    @cooperationEditForm = "form.cooperation-edit-form"

    @bindEvent()
  that = this

  # 页面加载时加载省
  $.ajax
    url: Store.context + "/api/address/provinces"
    type: "GET"
    success: (data)->
      s = "<option value=''>请选择</option>"
      s = s + "<option value="+item.id+">"+item.name+"</option>" for item in data.data
      $("#provinceId").html(s)
  #  省加载结束

  bindEvent: ->
    that = this

    $(that.cooperationEditForm).validator
      isErrorOnParent: true
    $(that.cooperationEditForm).on "submit", @cooperationCreateSubmit
  bindTempEvent :->
#  省点击触发市的函数
  $(".js-cooperation-selectCity").change ->
    provinceId = $("#provinceId").val()
    #    当点击的是请选择时候不做操作
    if '' is provinceId
      $("#cityId").html("<option value=''>请选择</option>")
      $("#areaId").html("<option value=''>请选择</option>")
      return
    $.ajax
      url: Store.context + "/api/address/province/#{provinceId}/cities"
      type: "GET"
      success: (data)->
        s = "<option value=''>请选择</option>"
        s = s + "<option value="+item.id+">"+item.name+"</option>" for item in data.data
        $("#cityId").html(s)
        $("#areaId").html("<option value=''>请选择</option>")

  #   市点击触发区的函数
  $(".js-cooperation-selectDistrict").change ->
    cityId = $("#cityId").val()
    #    当点击的是请选择时候不做操作
    if '' is cityId
      $("#areaId").html("<option value=''>请选择</option>")
      return
    $.ajax
      url: Store.context + "/api/address/city/#{cityId}/districts"
      type: "GET"
      success: (data)->
        s = "<option value=''>请选择</option>"
        s = s + "<option value="+item.id+">"+item.name+"</option>" for item in data.data
        $("#areaId").html(s)

  cooperationCreateSubmit: (evt)->
    evt.preventDefault()
    $(that.cooperationEditForm).validator
      isErrorOnParent: true

    data = $("form.cooperation-edit-form").serializeObject();
    #    获取select选择的内容
    data.province = $("#provinceId").find("option:selected").text();
    data.city = $("#cityId").find("option:selected").text();
    data.area = $("#areaId").find("option:selected").text();
    #    特殊字符校验开始
    if !/^[a-zA-Z0-9_]+$/.test data.vendorId  #合作商编码
      that.tip $("#vendorId").parent(),"error", "up", "只能输入数字、字母、下划线！"
      $(".tip").css("left", 180).css("top", 36)
      $("body").scrollTop $("#vendorId").offset().top-20
      return
    if data.merId!=''
      if !/^[a-zA-Z0-9_]+$/.test data.merId  #商户号
        that.tip $("#merId").parent(),"error", "up", "只能输入数字、字母、下划线！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#vendorId").offset().top-20
        return
    if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.fullName  #供应商名称
      that.tip $("#fullName").parent(),"error", "up", "不能输入特殊字符！"
      $(".tip").css("left", 180).css("top", 36)
      $("body").scrollTop $("#vendorId").offset().top-20
      return
    if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.simpleName  #供应商简称
      that.tip $("#simpleName").parent(),"error", "up", "不能输入特殊字符！"
      $(".tip").css("left", 180).css("top", 36)
      $("body").scrollTop $("#vendorId").offset().top-20
      return
    if data.taxCode!=''
      if !/^[a-zA-Z0-9_]+$/.test data.taxCode  #纳税登记号
        that.tip $("#taxCode").parent(),"error", "up", "只能输入数字、字母、下划线！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#vendorId").offset().top-20
        return
    if data.vendorType!=''
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.vendorType  #类型
        that.tip $("#vendorType").parent(),"error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#vendorId").offset().top-20
        return
    if data.payCondition!=''
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.payCondition  #付款条件
        that.tip $("#payCondition").parent(),"error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#vendorId").offset().top-20
        return
    if data.payGroup!=''
      if !/^[a-zA-Z0-9_]+$/.test data.payGroup  #支付组
        that.tip $("#payGroup").parent(),"error", "up", "只能输入数字、字母、下划线！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#vendorId").offset().top-20
        return
    if data.payWay!=''
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.payWay  #付款方法
        that.tip $("#payWay").parent(),"error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#vendorId").offset().top-20
        return
    if data.payCurrency!=''
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.payCurrency  #付款币种
        that.tip $("#payCurrency").parent(),"error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#vendorId").offset().top-20
        return
    if data.freightTip!=''
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.freightTip  #运费条款
        that.tip $("#freightTip").parent(),"error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#vendorId").offset().top-20
        return
    if data.cooperAddress!=''
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.cooperAddress  #供应商地点
        that.tip $("#cooperAddress").parent(),"error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#vendorId").offset().top-20
        return
    if data.enterpriseAddress!=''
      if !/^([\u4e00-\u9fa5\-—]+|[\u4e00-\u9fa5a-zA-Z_0-9\-—]+)$/.test data.enterpriseAddress  #企业地址
        that.tip $("#enterpriseAddress").parent(),"error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#vendorId").offset().top-20
        return
    if data.payAddress!=''
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.payAddress  #用于支付地点
        that.tip $("#payAddress").parent(),"error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#vendorId").offset().top-20
        return
    if data.buyAddress!=''
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.buyAddress  #用于采购地点
        that.tip $("#buyAddress").parent(),"error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#vendorId").offset().top-20
        return
    if data.payConditionAddress!=''
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.payConditionAddress  #付款条件地点
        that.tip $("#payConditionAddress").parent(),"error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#vendorId").offset().top-20
        return
    if data.payGroupAddress!=''
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.payGroupAddress  #支付组地点
        that.tip $("#payGroupAddress").parent(),"error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#vendorId").offset().top-20
        return
    if data.address!=''
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.address  #收货地点
        that.tip $("#address").parent(),"error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#vendorId").offset().top-20
        return
    if data.debtAccount!=''
      if !/^[a-zA-Z0-9_]+$/.test data.debtAccount  #负债账户
        that.tip $("#debtAccount").parent(),"error", "up", "只能输入数字、字母、下划线！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#vendorId").offset().top-20
        return
    if data.prepayAccount!=''
      if !/^[a-zA-Z0-9_]+$/.test data.prepayAccount  #预付款账户
        that.tip $("#prepayAccount").parent(),"error", "up", "只能输入数字、字母、下划线！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#vendorId").offset().top-20
        return
    if data.contact!=''
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.contact  #联系人名称
        that.tip $("#contact").parent(),"error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36)
        return
    if data.invoice!=''
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.invoice  #发票匹配选项
        that.tip $("#invoice").parent(),"error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36)
        return
    if data.accBank!=''
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.accBank  #收款银行名称
        that.tip $("#accBank").parent(),"error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36)
        return
    if data.accNo!=''
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.accNo  #银行帐号
        that.tip $("#accNo").parent(),"error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36)
        return
    if data.unionPayNo!=''
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.unionPayNo  #银联商户号
        that.tip $("#unionPayNo").parent(),"error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36)
        return
    venCode = $(".vMCode").val()
    if !/^[a-zA-Z0-9_]+$/.test venCode  #用户编号
      that.tip $(".vMCode").parent(),"error", "up", "只能输入数字、字母、下划线！"
      $(".tip").css("left", 180).css("top", 36)
      return
    vendName = $(".vName").val()
    if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test vendName  #用户姓名
      that.tip $(".vName").parent(),"error", "up", "不能输入特殊字符！"
      $(".tip").css("left", 180).css("top", 36)
      return
    venAddress = $(".vAddress").val()
    if venAddress!=''
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test venAddress  #通讯地址
        that.tip $(".vAddress").parent(),"error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36)
        return
    venDescript = $(".vDescript").val()
    if venDescript!=''
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test venDescript  #用户描述
        that.tip $(".vDescript").parent(),"error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36)
        return
    #    特殊字符校验结束

    #      校验开始
    if data.postCode!=''
      if !/[0-9]\d{5}(?!\d)/.test data.postCode #邮政编码
        that.tip $("#postCode").parent(),"error", "up", "请输入有效邮政编码！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#vendorId").offset().top-20
        return
#    if data.phone!=''
#      if !/^((0\d{2,3}-\d{7,8})|(1[3584]\d{9}))$/.test data.phone  #联系人电话
#        that.tip $("#phone").parent(),"error", "up", "请输入有效联系电话！"
#        $(".tip").css("left", 180).css("top", 36)
#        $("body").scrollTop $("#phone").offset().top-20
#        return
#    if data.contactTax!=''
#      if !/^[+]{0,1}(\d){1,3}[ ]?([-]?((\d)|[ ]){1,12})+$/.test data.contactTax  #联系人传真
#        that.tip $("#contactTax").parent(),"error", "up", "请输入有效的传真号码！"
#        $(".tip").css("left", 180).css("top", 36)
#        $("body").scrollTop $("#phone").offset().top-20
#        return
    if data.email!=''
      if !/\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.test data.email   #电子信箱
        that.tip $("#email").parent(),"error", "up", "请输入正确格式的邮箱账号！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#phone").offset().top-20
        return
    if data.accNo!=''
      if !/^\d{0,40}$/.test data.accNo   #银行帐号
        that.tip $("#accNo").parent(),"error", "up", "银行帐号格式不正确！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#phone").offset().top-20
        return
    if data.unionPayNo!=''
      if !/^\d{0,40}$/.test data.unionPayNo   #银联商户号
        that.tip $("#unionPayNo").parent(),"error", "up", "银联商户号不正确！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#unionPayNo").offset().top-20
        return
    vmobile = $(".vmobile").val()
    if vmobile!=''
      if !/^1[3|4|5|7|8][0-9]{9}$/.test vmobile  #手机号码
        that.tip $(".vmobile").parent(),"error", "up", "手机号码格式不正确！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#unionPayNo").offset().top-20
        return
    #     省市区校验
    provinceValue = $("#provinceId").val()
    cityValue = $("#cityId").val()
    areaValue = $("#areaId").val()
    if provinceValue isnt '710000' and provinceValue isnt '810000' and provinceValue isnt '820000'
      if provinceValue is '' || cityValue is '' || areaValue is ''
        new Modal(
          icon: "error"
          title: "温馨提示"
          content:"请填写完整的省市区!"
          overlay: true)
        .show()
        return

    #    密码校验及加密开始
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
      $("#passwordNew").parent().append("<span class=\"note-error js-error\"><i>&times;</i> "+checkMsgPwsecond+"</span>")
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
      $("#passwordConfirm").parent().append("<span class=\"note-error js-error\"><i>&times;</i> "+checkMsgPwfirst+"</span>")
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
    password = newPassword.substring(0, newPassword.length - 4)
    data.passwordFirst = password
    #    密码校验及加密结束
    vphone = $(".vphone").val()
#    if vphone!=''
#      if !/0\d{2,3}-\d{5,9}|0\d{2,3}-\d{5,9}/.test vphone  #联系电话
#        that.tip $(".vphone").parent(),"error", "up", "请输入有效联系电话！"
#        $(".tip").css("left", 180).css("top", 36)
#        return
    vfax = $(".vfax").val()
#    if vfax!=''
#      if !/^[+]{0,1}(\d){1,3}[ ]?([-]?((\d)|[ ]){1,12})+$/.test vfax  #传真电话
#        that.tip $(".vfax").parent(),"error", "up", "请输入有效传真电话！"
#        $(".tip").css("left", 180).css("top", 36)
#        return
    vmail = $(".vmail").val()
    if vmail!=''
      if !/\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.test vmail   #邮件地址
        that.tip $(".vmail").parent(),"error", "up", "请输入有效邮箱账号！"
        $(".tip").css("left", 180).css("top", 36)
        return

    #  合作商编码及用户编号的唯一性校验开始
    vendorId = $("#vendorId").val()
    vendorCode = $(".vMCode").val()
    $.ajax
      url:Store.context + "/api/admin/cooperation/add-check"
      type:"POST"
      data:{
        vendorId:vendorId
        vendorCode:vendorCode
      }
      success: (result)->
        if result.data.result==1
          that.tip $("#vendorId").parent(),"error", "up", "供应商编码已存在！"
          $(".tip").css("left", 180).css("top", 36)
          $("body").scrollTop $("#vendorId").offset().top-20
          return false
        else if result.data.result==2
          that.tip $(".vMCode").parent(),"error", "up", "用户编号已存在！"
          $(".tip").css("left", 180).css("top", 36)
          $("body").scrollTop $("#unionPayNo").offset().top-20
          return false
        else if result.data.result==3
          #特殊处理：供应商编码和用户编号都存在，先提示供应商编码存在（两个同时提示用户编号看不见提示信息）
          that.tip $("#vendorId").parent(),"error", "up", "供应商编码已存在！"
          $(".tip").css("left", 180).css("top", 36)
          $("body").scrollTop $("#vendorId").offset().top-20
          return false
        # 合作商编码及用户编号的唯一性校验结束

        $.ajax
          url: Store.context + "/api/admin/cooperation/add"
          type: "POST"
          data:data
          success: (data)->
            window.location.href = Store.context + "/points/cooperation/cooperation_all"

module.exports = PointsCooperationAdd
