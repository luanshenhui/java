tipAndAlert = require "tip_and_alert/tip_and_alert"
Modal = require "spirit/components/modal"
Store = require "extras/store"
passwordModifyTemplate = App.templates["password_modify"]

class adminTop
  _.extend @::, tipAndAlert
  that = this
  constructor: ->
    @noPower = ".admin-top .no-power"
    @brandCount = ".admin-top .brand-count"
    @firstCount = ".admin-top .first_count"
    @secondCount = ".admin-top .second_count"
    @waitUp = ".admin-top .wait-up"
    @priceCount = ".admin-top .price-count"
    @waitDown = ".admin-top .wait-down"
    @brandCountP = ".admin-top .brand-countp"
    @firstCountP = ".admin-top .first_countp"
    @secondCountP = ".admin-top .second_countp"
    @waitUpP = ".admin-top .wait-upp"
    @priceCountP = ".admin-top .price-countp"
    @waitDownP = ".admin-top .wait-downp"
    @modifyPasswordForm = "form.modify-password-form"
    @closeModifyPwd = ".close-modify-pwd"
    @setPriceP = ".set-price"
    @setPriceAuditP = ".set-price-audit"
    require.async(['/static/echarts/macarons.js','/static/echarts/echarts.common.min.js'], (a)->
      that.pageinit()
    )

    $.ajax
      url: Store.context + "/api/admin/user/pwdTimeout"
      type: "POST"
      success: (ret)->
        if !ret.data
          new Modal({
            icon: "error"
            title: "温馨提示"
            content:"您的密码已过期，请及时修改密码"
            overlay: false
          }).show(->that.showModifyPwd())
      error: (ret)->
        that.alert "body", "error", "出错啦！", ret.responseText
        $(".alert").css("z-index", 999)

    @bindEvent()

  bindEvent: ->
    that = this
    $(@noPower).on "click", @noPowerJs
    $(@brandCount).on "click", @toBrandAudit
    $(@firstCount).on "click", @toExamineFirst
    $(@secondCount).on "click", @toExamineSecond
    $(@waitUp).on "click", @toOnShelf
    $(@priceCount).on "click", @toWaittingChange
    $(@waitDown).on "click", @toDownShelf
    $(@brandCountP).on "click", @toBrandAuditP
    $(@firstCountP).on "click", @toExamineFirstP
    $(@secondCountP).on "click", @toExamineSecondP
    $(@waitUpP).on "click", @toOnShelfP
    $(@priceCountP).on "click", @toWaittingChangeP
    $(@waitDownP).on "click", @toDownShelfP
    $(@setPriceP).on "click", @toSetPriceP
    $(@setPriceAuditP).on "click", @toSetPriceAuditP


  axisLabel:(text) ->
    name = text
    if text
      if text.length > 7
        name = text.substr(0,7) + "..."
    return name

  showModifyPwd: ->
    new Modal(passwordModifyTemplate({title: "首次登录修改密码"})).show()
    $(that.modifyPasswordForm).validator
      isErrorOnParent: true
    $(that.modifyPasswordForm).on "submit", ->
      form = $(that.modifyPasswordForm).serializeObject()
      if form.passwordNew is form.passwordConfirm
        $.ajax
          url: Store.context + "/api/admin/user/modifyPwd"
          type: "POST"
          data: form
          success: (ret)->
            that.alert "body", "icons-true", "提示！", "修改密码成功"
            $(".alert").css("z-index", 999)
            $(that.closeModifyPwd).click()
          error: (ret)->
            $("body").spin(false)
            that.alert "body", "error", "出错啦！", ret.responseText
            $(".alert").css("z-index", 999)
      else
        that.alert "body", "error", "提示！", "两次密码输入不一致"
        $(".alert").css("z-index", 999)

  noPowerJs: ->
    that.alert "body", "error", "", "无此权限，请联系管理员"

  pageinit: ->
    vendorOrder = $('.vendor-order').data("vendor")
    vendorOrderName = []
    vendorOrderVal = []
    if(vendorOrder&&vendorOrder.length>0)
      $.each(vendorOrder, (i, data)->
        nameData = {}
        nameData.value = data.vendorName
        textStyle = {}
        textStyle.align = "right"
        nameData.textStyle = textStyle
        vendorOrderName.unshift nameData
        vendorOrderVal.unshift data.statNum01
      )
    brandOrder = $('.brand-order').data("brand")
    brandOrderName = []
    brandOrderVal = []
    if(brandOrder&&brandOrder.length>0)
      $.each(brandOrder, (i, data)->
        nameData = {}
        nameData.value = data.backCategory1Name
        textStyle = {}
        textStyle.align = "right"
        nameData.textStyle = textStyle
        brandOrderName.unshift nameData
        brandOrderVal.unshift data.statNum01
      )

    vendorOrderp = $('.vendor-orderp').data("vendor")
    vendorOrderNamep = []
    vendorOrderValp = []
    if(vendorOrderp&&vendorOrderp.length>0)
      $.each(vendorOrderp, (i, data)->
        nameData = {}
        nameData.value = data.vendorName
        textStyle = {}
        textStyle.align = "right"
        nameData.textStyle = textStyle
        vendorOrderNamep.unshift nameData
        vendorOrderValp.unshift data.statNum01
      )
    brandOrderp = $('.brand-orderp').data("brand")
    brandOrderNamep = []
    brandOrderValp = []
    if(brandOrderp&&brandOrderp.length>0)
      $.each(brandOrderp, (i, data)->
        nameData = {}
        nameData.value = data.backCategory1Name
        textStyle = {}
        textStyle.align = "right"
        nameData.textStyle = textStyle
        brandOrderNamep.unshift nameData
        brandOrderValp.unshift data.statNum01
      )
    # 基于准备好的dom，初始化echarts实例
    myChart = echarts.init(document.getElementById('echarts_categories'), e_macarons);
    option = {
      color : ["#1790cf"],
      tooltip :
        trigger: 'axis'
      calculable : true,
      grid :
        y : '0px',
        x : '20%'
      xAxis : [
        {
          type : 'value'
        }
      ],
      yAxis : [
        {
          axisLabel: formatter : @axisLabel
          type : 'category',
          data : brandOrderName
        }
      ],
      series : [
        {
          name:'销量',
          type:'bar',
          barWidth : '30',
          data:brandOrderVal
        }
      ]
    };

    myChart.setOption(option)
    # 基于准备好的dom，初始化echarts实例
    myChartOrder = echarts.init(document.getElementById('echarts_order'), e_macarons);
    optionOrder = {
      color : ["#1790cf"],
      tooltip :
        trigger: 'axis'
      calculable : true,
      grid :
        y : '0px'
        x : '24%'
      xAxis : [
        {
          type : 'value'
          splitLine:
            show: false
          axisLine:
            show: false
        }
      ],
      yAxis : [
        {
          axisLabel: formatter : @axisLabel
          type : 'category',
          data : vendorOrderName
        }
      ],
      series : [
        {
          name:'销量',
          type:'bar',
          barWidth: 30,
          data:vendorOrderVal
        }
      ]
    };
    myChartOrder.setOption(optionOrder)
    #积分的
    myChartp = echarts.init(document.getElementById('echarts_categoriesp'), e_macarons);
    optionp = {
      color : ["#1790cf"],
      tooltip :
        trigger: 'axis'
      calculable : true,
      grid :
        y : '0px',
        x : '20%'
      xAxis : [
        {
          type : 'value'
        }
      ],
      yAxis : [
        {
          axisLabel: formatter : @axisLabel
          type : 'category',
          data : brandOrderNamep
        }
      ],
      series : [
        {
          name:'销量',
          type:'bar',
          barWidth : '30',
          data:brandOrderValp
        }
      ]
    };

    myChartp.setOption(optionp)
    # 基于准备好的dom，初始化echarts实例
    myChartOrderp = echarts.init(document.getElementById('echarts_orderp'), e_macarons);
    optionOrderp = {
      color : ["#1790cf"],
      tooltip :
        trigger: 'axis'
      calculable : true,
      grid :
        y : '0px'
        x : '24%'
      xAxis : [
        {
          type : 'value'
          splitLine:
            show: false
          axisLine:
            show: false
        }
      ],
      yAxis : [
        {
          axisLabel: formatter : @axisLabel
          type : 'category',
          data : vendorOrderNamep
        }
      ],
      series : [
        {
          name:'销量',
          type:'bar',
          barWidth: 30,
          data:vendorOrderValp
        }
      ]
    };
    myChartOrderp.setOption(optionOrderp)


  toBrandAudit: ->
    window.location.href=Store.context + "/mall/brands/brands-info-waitting"
  toExamineFirst: ->
    window.location.href=Store.context + "/mall/item/waitting-first-exam"
  toExamineSecond: ->
    window.location.href=Store.context + "/mall/item/waitting-second-exam"
  toOnShelf: ->
    window.location.href=Store.context + "/mall/item/waitting-on-shelf"
  toWaittingChange: ->
    window.location.href=Store.context + "/mall/item/waitting-change-exam"
  toDownShelf: ->
    window.location.href=Store.context + "/mall/item/down-shelf-goods"


  toBrandAuditP: ->
    window.location.href=Store.context + "/points/brands/brands-info-waitting"
  toExamineFirstP: ->
    window.location.href=Store.context + "/points/item/pending-first-trail"
  toExamineSecondP: ->
    window.location.href=Store.context + "/points/item/pending-review"
  toOnShelfP: ->
    window.location.href=Store.context + "/points/item/pending-grounding"
  toWaittingChangeP: ->
    window.location.href=Store.context + "/points/item/change-reviewed"
  toDownShelfP: ->
    window.location.href=Store.context + "/points/item/pull-off-reviewed"
  #定价
  toSetPriceP: ->
    window.location.href=Store.context + "/points/item/pending-priced"
  #定价审核
  toSetPriceAuditP: ->
    window.location.href=Store.context + "/points/item/pending-priced-reviewed"


module.exports = adminTop