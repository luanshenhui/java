Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"

class CashScale
  _.extend @::, TipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show();
  constructor: ->
    @bindEvent()
  that = this

  bindEvent: ->
    that = this
    $(".js-cash-submit").on "click", @submitCashScale


  submitCashScale: ->
    result = $("form.cash-scale-form").serializeObject()
#    校验开始
    numval = Number(result.argumentOther)
    slId = $.trim(result.argumentOther)
    if isNaN(numval) || numval<0 || numval>1 || slId =="" #现金比例
      that.alert "body", "error", "请输入0～1最多2位小数的数！"
      return
#    校验结束
    $.ajax
      url: Store.context + "/api/admin/priceSystem/edit"
      type: "POST"
      data: result
      success: (data)->
        window.location.reload()
      error: (data) ->


module.exports = CashScale