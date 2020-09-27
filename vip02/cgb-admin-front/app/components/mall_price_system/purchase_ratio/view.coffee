Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"
tipAndAlert = require "tip_and_alert/tip_and_alert"

class PurchaseRatio
  _.extend @::, tipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show();
  constructor: ->
    @bindEvent()
  that = this

  bindEvent: ->
    that = this
    $(".js-purchase-submit").on "click", @submitPurchaseRatio


  submitPurchaseRatio:(evt) ->
    evt.preventDefault()
    result = $("form.purchase-ratio-form").serializeObject()
#    校验开始
    numval = Number(result.cfgValue1)
    slId = $.trim(result.cfgValue1)
    if isNaN(numval) || numval<0 || numval>1 || slId == ""  #采购价格上浮系数
      that.alert "body", "error", "请输入0～1最多2位小数的数！"
      $(".alert").css("z-index":9999)
      return
#    校验结束
    $.ajax
      url: Store.context + "/api/admin/priceSystem/purchaseUpdate"
      type: "POST"
      data: result
      success: (data)->
        window.location.reload()
      error: (data) ->


module.exports = PurchaseRatio