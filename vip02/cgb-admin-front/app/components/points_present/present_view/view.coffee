Modal = require "spirit/components/modal"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"
spuTemplate = App.templates["item_spu_properties"]
class PresentView
  _.extend @::, TipAndAlert
  constructor: ->
    text = $('.js-introduction').data('introduction')
    require.async(['/static/umeditor/umeditor.config.js', '/static/umeditor/umeditor.min.js'], (a)->
      um = UM.getEditor('myEditor', {
        zIndex: 99
      });
      um.addListener "ready", ->
        um.setContent(text)
        um.setDisabled('fullscreen')
    )
    @spuId = $("#spuId").val()
    @$itemPicBtn=$(".item-image-li")
    @$examPassBtn = $(".js-exam-pass") #审核通过按钮
    @$examRejectBtn = $(".js-exam-reject") #审核拒绝按钮
    @orderReturn = ".orderReturn" #返回订单页
    @approveMemo = ".js-approve-memo"
    @bindEvent()

  that = this
  bindEvent: ->
    that = this
    @setSpus(@spuId)
    @$itemPicBtn.on "click",@enlargeImage #放大图片
    @$examPassBtn.on "click", @examGoods
    @$examRejectBtn.on "click", @examGoods
    $(".admin-btn").on "click", @orderReturn, @orderBack
    $(document).on "keydown keyup keypress", @approveMemo, ->
      that.areaTextListener(200, $(@)) ## 监听area显示可输入字数
    $(document).on "focus blur", @approveMemo, ->
      that.areaTextListener(200, $(@)) ## 监听area显示可输入字数


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

  checkCard:(card)->
    count=0
    if card is "WWWW"
      count++
    if /^(\d{4}\,)*?\d{4}$/.test(card)
      count++
    return count


  examGoods: (evt)->
    goodsCode = $(".js-title").data("id")       ##审核礼品ID
    approveType = $(".js-title").data("type")
    approveResult = $(@).data("result")           ##通过、拒绝的flag
    approveMemo = $(".js-approve-memo").val()     ##通过、拒绝的理由
    count = that.checkCard($(".js-edit-cards").val())
    if count isnt 1
      that.alert "body", "error", "第三级卡产品编码输入格式不正确！"
      return
    if approveResult is "reject" && approveMemo is ""
      that.alert "body", "error", "请填写审核意见！"
      return
    params={}
    params.code =  goodsCode #商品编码
    params.approveType =  approveType #审核类型
    params.approveResult = approveResult #审核结果 通过值为pass,拒绝 reject
    params.approveMemo = approveMemo #审核意见
    params.cards  = $(".js-edit-cards").val() #第三级卡产品编码
    params.channel = "JF"
    $.ajax
      url: Store.context + "/api/admin/goods/audit/#{goodsCode}"
      type: "POST"
      data: params
      success: (data)->
        that.alert "body", "success", "审核完成！"
        location.href =Store.context +  "/points/item/all-present"


## 文本域监听,显示可输入的字数
  areaTextListener: (i, self)->
    val = self.val()
    length = parseInt(val.length)
    text = i - length
    if length >= i
      self.val(val.substr(0, i))
      text = 0
    #    $(".remaining-text i").text(text)
    self.next().find("i").text(text)

module.exports = PresentView