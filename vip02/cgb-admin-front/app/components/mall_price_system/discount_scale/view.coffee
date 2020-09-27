Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"

class DiscountScale
  _.extend @::, TipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show();
  constructor: ->
    @discountScaleUpdate = ".js-discount-scale-edit"
    @bindEvent()
  that = this
  discountScaleTemplate = App.templates["discount_scale_edit"]


  bindEvent: ->
    that = this
    $(".discount-scale").on "click", @discountScaleUpdate, @updateDiscountScale



  updateDiscountScale: ->
    data = $(@).closest("tr").data("data")
    new Modal(discountScaleTemplate({data: data})).show()
    $("form.discount-scale-form").validator
      isErrorOnParent: true
    $("form.discount-scale-form").on "submit", that.discountScaleEdit

  discountScaleEdit: (evt)->
    evt.preventDefault()
    $("form.discount-scale-form").validator
      isErrorOnParent: true

    result = $("form.discount-scale-form").serializeObject()
    #    校验开始
    if !/^00?\.(?:0[1-9]|[1-9][0-9]?)$/.test result.argumentOther #折扣比例
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

module.exports = DiscountScale