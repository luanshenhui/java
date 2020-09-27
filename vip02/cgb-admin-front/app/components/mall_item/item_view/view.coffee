TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"
spuTemplate = App.templates["item_spu_properties"]
class ItemView
  _.extend @::, TipAndAlert
  constructor: ->
    text = $('.js-introduction').data('introduction')
    require.async(['/static/umeditor/umeditor.config.js', '/static/umeditor/umeditor.min.js'], (a)->
      um = UM.getEditor('editor', {
        zIndex: 99
      });
      um.addListener "ready", ->
        um.setContent(text)
        um.setDisabled('fullscreen')
    )
    @spuId = $("#spuId").val()
    @$examPassBtn = $(".js-exam-pass") #审核通过按钮
    @$examRejectBtn = $(".js-exam-reject") #审核拒绝按钮
    @$pictureViewBtn = $(".js-picture-view") #单品表格中的查看按钮
    @orderReturn = ".orderReturn" #返回订单页
    @$itemPicBtn=$(".item-image-li")
    @$pointRateInput = $(".js-edit-rate")
    @bindEvent()

  that = this
  bindEvent: ->
    that = this
    @setSpus(@spuId)
    @$itemPicBtn.on "click",@enlargeImage #放大图片
    @$examPassBtn.on "click", @examGoods
    @$examRejectBtn.on "click", @examGoods
    @$pictureViewBtn.on "click", @pictureView #查看单品图片
    $(".admin-btn").on "click", @orderReturn, @orderBack
    @$pointRateInput.on "blur", @showOnlyFlag



  setSpus: (spuId)->
    $.get Store.context + "/api/admin/spuDetail/#{spuId}", (data)->
      $(".spu").append(spuTemplate({data: data.data.spuAttributes}))

  enlargeImage:->
    html = '<div class="pop-up" style="display: block;" onclick="$(\'.pop-up\').remove()">'
    html = html + '<img width="600px" height="400px"class="img-center" src='
    html = html + ($(@).find("img").attr('src'))
    html = html + '></div>'
    $("body").append(html)


  orderBack: ->
    window.history.go(-1);

  forDelay=_.debounce(((goodsCode,approveType,approveResult,approveMemo,modifyTime)->
    $.ajax
      url: Store.context + "/api/admin/goods/audit/#{goodsCode}"
      type: "POST"
      data:approveType:approveType,approveResult:approveResult,approveMemo:approveMemo,modifyTime:modifyTime
      success: (data)->
        that.alert "body", "success", "审核完成！"
        window.location.href = Store.context +  "/mall/item/all-goods"
  ), 3000,true)

  #供应商端取消第三级卡产品编码 FROM 修改 chenle 2016.11.2 2016.11.3
  showOnlyFlag: (evt)->
    rate = $(".js-edit-rate").val()
    $(".js-display-flag").css('display', 'none')
    if rate isnt ""
      if  !/^([01](\.0+)?|0\.[0-9]+)$/.test rate
        that.alert "body", "error", "积分支付比例输入不符合规则！"
        return
      if Number(rate) is 1
        $(".js-display-flag").css('display', 'block')

  checkData:(card)->
    count=0
    if card is "WWWW"
      count++
    if /^(\d{4}\,)*?\d{4}$/.test(card)
      count++
    return count

  getDisplayFlag:->
    displayFlag = 0
    productPointRate = $(".js-edit-rate").val()
    if productPointRate
      if Number(productPointRate) is 1 and $("input[name='displayFlag']").is(':checked')
        displayFlag = 1
    return displayFlag

  examGoods:(evt)->
    goodsCode = $(".js-title").data("id")
    approveResult = $(@).data("result")   #通过值为pass,拒绝 reject
    approveMemo = $(".js-approve-memo").val() #审核意见
    count = that.checkData($(".js-edit-cards").val())
    if count isnt 1
      that.alert "body", "error", "第三级卡产品编码输入格式不正确！"
      return
    if approveResult is "reject" && approveMemo is ""
      that.alert "body", "error", "请填写审核意见！"
      return
    if approveMemo isnt ""
      if  approveMemo.length > 100
        that.alert "body", "error", "审核意见最多可输入100个字符！"
        return
    displayFlag=that.getDisplayFlag()
    params={}
    params.code =  $(".js-title").data("id") #商品编码
    params.approveType =  $(".js-strong").data("type") #审核类型
    params.approveResult = approveResult #审核结果 通过值为pass,拒绝 reject
    params.approveMemo = approveMemo #审核意见
    params.rate = $(".js-edit-rate").val() #积分支付比例
    params.cards  = $(".js-edit-cards").val() #第三级卡产品编码
    params.displayFlag = displayFlag
    params.channel = "YG"
    $("body").spin("medium")
    $.ajax
      url: Store.context + "/api/admin/goods/audit/#{goodsCode}"
      type: "POST"
      data: params
      success: (data)->
        that.alert "body", "success", "审核完成！"
        window.location.href = Store.context + "/mall/item/all-goods"
      complete: ->
        $("body").spin(false)
  #供应商端取消第三级卡产品编码 TO 修改 chenle 2016.11.2 2016.11.3

module.exports = ItemView