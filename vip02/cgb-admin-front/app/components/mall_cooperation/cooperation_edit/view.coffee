tipAndAlert = require "tip_and_alert/tip_and_alert"
Modal = require "spirit/components/modal"
Store = require "extras/store"

class MallCooperationEdit
  _.extend @::, tipAndAlert
  arrayRate = []
  arrayMail = []
  constructor: ->
    @cooperationEditForm = "form.cooperation-edit-form"
    @rateDelete = ".js-rate-delete"
    @mailStagesDelete = ".js-mail-stages-delete"
    @changeTotalStage = ".totalStage"
    @changeHtflag = ".htflag"
    @bindEvent()
  that = this
  bindTempEvent :->
  # 页面加载时加载省
  provinceId = $("#provinces").val()
  cityId = $("#citys").val()
  areaId = $("#areas").val()
  $.ajax
    url: Store.context + "/api/address/provinces"
    type: "GET"
    success: (data)->
      s = "<option value=''>请选择</option>"
      s = s + "<option value="+item.id+">"+item.name+"</option>" for item in data.data
      $("#provinceId").html(s)
      $("#provinceId").val(provinceId)
      $.ajax
        url:Store.context +  "/api/address/province/#{provinceId}/cities"
        type: "GET"
        success: (data)->
          s = "<option value=''>请选择</option>"
          s = s + "<option value="+item.id+">"+item.name+"</option>" for item in data.data
          $("#cityId").html(s)
          $("#cityId").val(cityId)
          $.ajax
            url: Store.context + "/api/address/city/#{cityId}/districts"
            type: "GET"
            success: (data)->
              s = "<option value=''>请选择</option>"
              s = s + "<option value="+item.id+">"+item.name+"</option>" for item in data.data
              $("#areaId").html(s)
              $("#areaId").val(areaId)

#  省加载结束
#  省点击触发市的函数
  $(".js-cooperation-selectCity").change ->
    provinceId = $("#provinceId").val()
#    当点击的是请选择时候不做操作
    if '' is provinceId
      $("#cityId").html("<option value=''>请选择</option>")
      $("#areaId").html("<option value=''>请选择</option>")
      return
    $.ajax
      url:Store.context +  "/api/address/province/#{provinceId}/cities"
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


  bindEvent: ->
    that = this
    #  合并和展开
    $(".subNav").on "click", @openAndClose
    #分期费率的增加删除
    $(".js-rate-add").on "click", @addRate
    $(document).on "click",@rateDelete, @deleteRate

    $(document).on "change",@changeTotalStage, @selectTotalStage
    $(document).on "change",@changeHtflag, @selectHtflag

    #邮购分期类别码
    $(".js-mail-stages-add").on "click", @addMailStages
    $(document).on "click",@mailStagesDelete, @deleteMailStages

    $(that.cooperationEditForm).validator
      isErrorOnParent: true
    $(that.cooperationEditForm).on "submit", @cooperationUpdateSubmit

  openAndClose:->
    $(this).toggleClass("currentDd")
    $(this).toggleClass("currentDt")
    if $(this).next().css("display") != "none"
      $(this).find(".detail-open").hide()
      $(this).find(".detail-close").show()
    else
      $(this).find(".detail-open").show()
      $(this).find(".detail-close").hide()
    $(this).next(".navContent").slideToggle(200);

  selectTotalStage: ->
    count = $(this).val()
    $(this).closest(".js-rate-info").find(".rate-span").html(count+"期费率")
    if count is "1"
      $(this).closest(".js-rate-info").find(".feeratio2").attr("readonly","readonly")
      $(this).closest(".js-rate-info").find(".ratio2Precent").attr("readonly","readonly")
      $(this).closest(".js-rate-info").find(".feeratio2Bill").attr("readonly","readonly")
      $(this).closest(".js-rate-info").find(".feeratio3").attr("readonly","readonly")
      $(this).closest(".js-rate-info").find(".ratio3Precent").attr("readonly","readonly")
      $(this).closest(".js-rate-info").find(".feeratio3Bill").attr("readonly","readonly")
    else
      $(this).closest(".js-rate-info").find(".feeratio2").removeAttr("readonly")
      $(this).closest(".js-rate-info").find(".ratio2Precent").removeAttr("readonly")
      $(this).closest(".js-rate-info").find(".feeratio2Bill").removeAttr("readonly")
      $(this).closest(".js-rate-info").find(".feeratio3").removeAttr("readonly")
      $(this).closest(".js-rate-info").find(".ratio3Precent").removeAttr("readonly")
      $(this).closest(".js-rate-info").find(".feeratio3Bill").removeAttr("readonly")
  selectHtflag: ->
    htflag = $(this).val()
    if htflag is "4" or htflag is "5"
      $(this).closest(".js-rate-info").find(".htant").removeAttr("readonly")
    else
      if htflag is "1" or htflag is "2" or htflag is "3"
        $(this).closest(".js-rate-info").find(".htant").attr("readonly","readonly")

  cooperationUpdateSubmit: (evt)->
    evt.preventDefault()
    $(that.cooperationEditForm).validator
      isErrorOnParent: true
    data = $("form.cooperation-edit-form").serializeObject();
    #    获取select选择的内容
    data.province = $("#provinceId").find("option:selected").text();
    data.city = $("#cityId").find("option:selected").text();
    data.area = $("#areaId").find("option:selected").text();

#    特殊字符校验开始
    if data.merId!=''
      if !/^[a-zA-Z0-9_]+$/.test data.merId  #商户号
        that.tip $("#merId").parent(),"error", "up", "只能输入数字、字母、下划线！"
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
        $("body").scrollTop $("#vendorId").offset().top-20
        return
    if data.accBank!=''
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.accBank  #收款银行名称
        that.tip $("#accBank").parent(),"error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#vendorId").offset().top-20
        return
    if data.accNo!=''
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.accNo  #银行帐号
        that.tip $("#accNo").parent(),"error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#vendorId").offset().top-20
        return
    if data.unionPayNo!=''
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.unionPayNo  #银联商户号
        that.tip $("#unionPayNo").parent(),"error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#unionPayNo").offset().top-20
        return
    if data.vendorNo!=''
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.vendorNo  #供应商代码
        that.tip $("#vendorNo").parent(),"error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#unionPayNo").offset().top-20
        return
    if data.virtualVendorId!=''
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.virtualVendorId  #虚拟特店号
        that.tip $("#virtualVendorId").parent(),"error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#unionPayNo").offset().top-20
        return
    venCode = $(".vMCode").val()
    if !/^[a-zA-Z0-9_]+$/.test venCode  #用户编号
      that.tip $(".vMCode").parent(),"error", "up", "只能输入数字、字母、下划线！"
      $(".tip").css("left", 300).css("top", 36).css("z-index",9999)
      $("body").scrollTop $("#unionPayNo").offset().top-20
      return
    vendName = $(".vName").val()
    if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test vendName  #用户姓名
      that.tip $(".vName").parent(),"error", "up", "不能输入特殊字符！"
      $(".tip").css("left", 300).css("top", 36).css("z-index",9999)
      $("body").scrollTop $("#unionPayNo").offset().top-20
      return
    venDescript = $(".vDescript").val()
    if venDescript!=''
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test venDescript  #用户描述
        that.tip $(".vDescript").parent(),"error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#unionPayNo").offset().top-20
        return

#    特殊字符校验结束
    if data.commision!=''
      if !/^[0]+([.]{1}[0-9]+){0,1}$/.test data.commision #佣金率
        that.tip $("#commision").parent(),"error", "up", "请输入小于1的正小数！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#vendorId").offset().top-20
        return
    if data.postCode!=''
      if !/[0-9]\d{5}(?!\d)/.test data.postCode #邮政编码
        that.tip $("#postCode").parent(),"error", "up", "请输入有效邮政编码！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#vendorId").offset().top-20
        return
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
    if newPasswordObj.GetPL() isnt 0
      checkMsgPwsecond = checkPwdObject1(newPasswordObj, '一次密码', "222", '4位', null)
      if "" isnt checkMsgPwsecond
        $("#passwordNew").siblings(".note").hide()
        $("#passwordNew").parent().append("<span class=\"note-error js-error\"><i>&times;</i> "+checkMsgPwsecond+"</span>")
        $("#passwordNew").siblings(".note-error").show()
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
#        $("body").scrollTop $("#unionPayNo").offset().top-20
#        return
    vfax = $(".vfax").val()
#    if vfax!=''
#      if !/^[+]{0,1}(\d){1,3}[ ]?([-]?((\d)|[ ]){1,12})+$/.test vfax  #传真电话
#        that.tip $(".vfax").parent(),"error", "up", "请输入有效传真！"
#        $(".tip").css("left", 180).css("top", 36)
#        $("body").scrollTop $("#unionPayNo").offset().top-20
#        return
    vmail = $(".vmail").val()
    if vmail!=''
      if !/\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.test vmail   #邮件地址
        that.tip $(".vmail").parent(),"error", "up", "邮件地址格式不正确！"
        $(".tip").css("left", 180).css("top", 36)
        $("body").scrollTop $("#unionPayNo").offset().top-20
        return

    result = true
    #分期费率校验开始
    $("#rate-list").find(".js-rate-info").each ->
      $(@).find(".fixedamtFee-required-error").remove()  #固定金额手续费
      $(@).find(".feeratio1-required-error").remove()  #手续费费率1(月费率)
      $(@).find(".ratio1Precent-required-error").remove()  #费率1本金百分比
      $(@).find(".feeratio2-required-error").remove()  #手续费费率2(月费率)
      $(@).find(".ratio2Precent-required-error").remove()  #费率2本金百分比
      $(@).find(".feeratio2Bill-required-error").remove()  #手续费费率2 开机期数
      $(@).find(".feeratio3-required-error").remove()  #手续费费率3(月费率)
      $(@).find(".ratio3Precent-required-error").remove()  #费率3本金百分比
      $(@).find(".feeratio3Bill-required-error").remove()  #手续费费率3 开机期数
      $(@).find(".reducerateFrom-required-error").remove()  #直接免除手续费期数FROM
      $(@).find(".reducerateTo-required-error").remove()  #直接免除手续费期数To
      $(@).find(".reducerate-required-error").remove()  #手续费免除期数
      $(@).find(".htant-required-error").remove()  #首尾付本金

      if !/^[0-9]+(\.[0-9]{1,6})?$/.test $(@).find(".fixedamtFee").val()  #固定金额手续费
        $(@).find(".fixedamtFee").parent().append("<span class=\"fixedamtFee-required-error required\"><i>&times;</i> 请输入最多6位小数的非负整数</span>")
        result = false
        return
      if !/^([1-9]\d{0,1}|0)(\.\d{1,5})?$/.test $(@).find(".feeratio1").val()  #手续费费率1(月费率)
        $(@).find(".feeratio1").parent().append("<span class=\"feeratio1-required-error required\"><i>&times;</i> 请输入0～1的数</span>")
        result = false
        return
      if !/^([1-9]\d{0,1}|0)(\.\d{1,5})?$/.test $(@).find(".ratio1Precent").val()  #费率1本金百分比
        $(@).find(".ratio1Precent").parent().append("<span class=\"ratio1Precent-required-error required\"><i>&times;</i> 请输入0～1的数</span>")
        result = false
        return
      if $(this).closest(".js-rate-info").find(".totalStage").val() isnt "1"
        if !/^([1-9]\d{0,1}|0)(\.\d{1,5})?$/.test $(@).find(".feeratio2").val()  #手续费费率2(月费率)
          $(@).find(".feeratio2").parent().append("<span class=\"feeratio2-required-error required\"><i>&times;</i> 请输入0～1的数</span>")
          result = false
          return
      if $(this).closest(".js-rate-info").find(".totalStage").val() isnt "1"
        if !/^([1-9]\d{0,1}|0)(\.\d{1,5})?$/.test $(@).find(".ratio2Precent").val()  #费率2本金百分比
          $(@).find(".ratio2Precent").parent().append("<span class=\"ratio2Precent-required-error required\"><i>&times;</i> 请输入0～1的数</span>")
          result = false
          return
      if $(this).closest(".js-rate-info").find(".totalStage") .val() isnt "1"
        if !/^[0-9]\d*$/.test $(@).find(".feeratio2Bill").val()  #手续费费率2 开机期数
          $(@).find(".feeratio2Bill").parent().append("<span class=\"feeratio2Bill-required-error required\"><i>&times;</i> 请输入非负整数</span>")
          result = false
          return
      if $(this).closest(".js-rate-info").find(".totalStage").val() isnt "1"
        if !/^([1-9]\d{0,1}|0)(\.\d{1,5})?$/.test $(@).find(".feeratio3").val()  #手续费费率3(月费率)
          $(@).find(".feeratio3").parent().append("<span class=\"feeratio3-required-error required\"><i>&times;</i> 请输入0～1的数</span>")
          result = false
          return
      if $(this).closest(".js-rate-info").find(".totalStage").val() isnt "1"
        if !/^([1-9]\d{0,1}|0)(\.\d{1,5})?$/.test $(@).find(".ratio3Precent").val()  #费率3本金百分比
          $(@).find(".ratio3Precent").parent().append("<span class=\"ratio3Precent-required-error required\"><i>&times;</i> 请输入0～1的数</span>")
          result = false
          return
      if $(this).closest(".js-rate-info").find(".totalStage").val() isnt "1"
        if !/^[0-9]\d*$/.test $(@).find(".feeratio3Bill").val()  #手续费费率3 开机期数
          $(@).find(".feeratio3Bill").parent().append("<span class=\"feeratio3Bill-required-error required\"><i>&times;</i> 请输入非负整数</span>")
          result = false
          return
      if !/^[0-9]\d*$/.test $(@).find(".reducerateFrom").val()  #直接免除手续费期数FROM
        $(@).find(".reducerateFrom").parent().append("<span class=\"reducerateFrom-required-error required\"><i>&times;</i> 请输入非负整数</span>")
        result = false
        return
      if $(this).closest(".js-rate-info").find(".totalStage").val() < $(this).closest(".js-rate-info").find(".reducerateFrom").val()  #直接免除手续费期数FROM
        $(@).find(".reducerateFrom").parent().append("<span class=\"reducerateFrom-required-error required\"><i>&times;</i> 不能大于总期数</span>")
        result = false
        return
      if !/^[0-9]\d*$/.test $(@).find(".reducerateTo").val()  #直接免除手续费期数TO
        $(@).find(".reducerateTo").parent().append("<span class=\"reducerateTo-required-error required\"><i>&times;</i> 请输入非负整数</span>")
        result = false
        return
      if $(this).closest(".js-rate-info").find(".reducerateFrom").val() > $(this).closest(".js-rate-info").find(".reducerateTo").val() #直接免除手续费期数TO
        $(@).find(".reducerateTo").parent().append("<span class=\"reducerateTo-required-error required\"><i>&times;</i> 不能小于开始期数</span>")
        result = false
        return
      if $(this).closest(".js-rate-info").find(".totalStage").val() < $(this).closest(".js-rate-info").find(".reducerateTo").val()  #直接免除手续费期数TO
        $(@).find(".reducerateTo").parent().append("<span class=\"reducerateTo-required-error required\"><i>&times;</i> 不能大于总期数</span>")
        result = false
        return
      if !/^[0-9]\d*$/.test $(@).find(".reducerate").val()  #手续费免除期数
        $(@).find(".reducerate").parent().append("<span class=\"reducerate-required-error required\"><i>&times;</i> 请输入非负整数</span>")
        result = false
        return
      if $(this).closest(".js-rate-info").find(".totalStage").val() < $(this).closest(".js-rate-info").find(".reducerate").val() #手续费免除期数
        $(@).find(".reducerate").parent().append("<span class=\"reducerate-required-error required\"><i>&times;</i> 不能大于总期数</span>")
        result = false
        return
      if $(this).closest(".js-rate-info").find(".htflag").val() is "4" or $(this).closest(".js-rate-info").find(".htflag").val() is "5"
        if !/^\d+(\.\d{0,2})?$/.test $(@).find(".htant").val()  #首尾付本金
          $(@).find(".htant").parent().append("<span class=\"htant-required-error required\"><i>&times;</i> 请输入最多2位小数的非负数</span>")
          result = false
          return
    #分期费率校验结束
    #邮购分期校验
    $("#mail-stages-list").find(".js-mail-stages-info").each ->
      $(@).find(".code-required-error").remove()  #邮购分期类别码
      $(@).find(".name-required-error").remove()  #邮购分期类别名称

      if $(@).find(".code").val() ==''  #邮购分期类别码
        $(@).find(".code").parent().append("<span class=\"code-required-error required\"><i>&times;</i> 必填 不得为空</span>")
        result = false
        return
      else
        if !/^[a-zA-Z0-9]{1,20}$/.test $(@).find(".code").val()  #邮购分期类别码
          $(@).find(".code").parent().append("<span class=\"code-required-error required\"><i>&times;</i> 只能输入数字和字母</span>")
          result = false
          return
      if $(@).find(".name").val() ==''  #邮购分期类别名称
        $(@).find(".js-mail-stages-delete").parent().append("<span class=\"name-required-error required\"><i>&times;</i> 必填 不得为空</span>")
        result = false
        return
    if result is false
      return

        #分期费率的数组循成list
    data.tblVendorRatioModelList=[]
    $(".js-rate-info").each ->
      item={}
      item.id=$(@).find("#id").val()
      item.period =$(@).find("#period").val()
      item.fixedfeehtFlag = $(@).find("#fixedfeehtFlag").val()
      item.fixedamtFee = $(@).find("#fixedamtFee").val()
      item.feeratio1 = $(@).find("#feeratio1").val()
      item.ratio1Precent = $(@).find("#ratio1Precent").val()
      item.feeratio2 = $(@).find("#feeratio2").val()
      item.ratio2Precent = $(@).find("#ratio2Precent").val()
      item.feeratio2Bill = $(@).find("#feeratio2Bill").val()
      item.feeratio3 = $(@).find("#feeratio3").val()
      item.ratio3Precent = $(@).find("#ratio3Precent").val()
      item.feeratio3Bill = $(@).find("#feeratio3Bill").val()
      item.reducerateFrom = $(@).find("#reducerateFrom").val()
      item.reducerateTo = $(@).find("#reducerateTo").val()
      item.reducerate = $(@).find("#reducerate").val()
      item.htflag = $(@).find("#htflag").val()
      item.htant = $(@).find("#htant").val()
      data.tblVendorRatioModelList.push(item)
    data.stageRate = JSON.stringify data
#    邮购分期的数组循成list
    data.mailStagesModelList=[]
    $(".js-mail-stages-info").each ->
      item={}
      item.id=$(@).find("#mailStagesId").val()
      item.code =$(@).find("#code").val()
      item.name = $(@).find("#name").val()
      data.mailStagesModelList.push(item)
    data.mailStages = JSON.stringify data
#分期费率和邮购分期id集合转化为字符串
    data.stageRateIdList = JSON.stringify arrayRate
    data.mailStagesIdList = JSON.stringify arrayMail
    $.ajax
      url: Store.context + "/api/admin/cooperation/edit"
      type: "POST"
      data: data
      success: (data)->
        window.location.href =Store.context +  "/mall/cooperation/cooperation_all"

  addRate: ->
    rate = $("#addStageRate").html()
    $("#rate-list").append(rate)

  deleteRate:->
    rateIdVal = $(this).closest(".js-rate-info").find(".rate-id").val()
    if rateIdVal isnt "" and rateIdVal isnt undefined  and  rateIdVal isnt null
      arrayRate.push($(this).closest(".js-rate-info").find(".rate-id").val())
    $(this).parent().parent('.rate').remove()

  addMailStages: ->
    mailStages = $("#addMailStages").html()
    $("#mail-stages-list").append(mailStages)

  deleteMailStages:->
    length = $("#mail-stages-list").find(".mail-stages").length;
    if length is 1
      new Modal(
        icon: "error"
        title: "温馨提示！"
        content: "已经是最后一个，不允许删除！"
        overlay: true)
      .show()
      return false
    mailIdVal = $(this).closest(".js-mail-stages-info").find(".mail-id").val()
    if mailIdVal isnt "" and mailIdVal isnt undefined  and  mailIdVal isnt null
      arrayMail.push($(this).closest(".js-mail-stages-info").find(".mail-id").val())
    $(this).parent().parent('.mail-stages').remove()
module.exports = MallCooperationEdit
