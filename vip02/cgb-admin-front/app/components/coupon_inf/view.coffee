Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"
tipAndAlert = require "tip_and_alert/tip_and_alert"
class couponInf
  _.extend @::, tipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
    @setCoupon = $(".js-a-href")#点击设置 页面跳转
    @getCoupon = $(".js-coupon-get")#点击获取
    @bindEvent()
  that = this

  bindEvent: ->
    that = this
    @setCoupon.on "click", @couponSet #点击设置 页面跳转
    @getCoupon.on "click", @couponGet #点击设置 页面跳转

  couponSet: ->
    id = $(@).closest("tr").data("id")
    location.href = Store.context + "/mall/coupon_set?id=" + id
#    $.ajax
#      url: Store.context + "/api/admin/coupon/" + id
#      type: "POST"
#      data:
#        id: id
#      success: (data)->
#        location.href = "coupon_set"
  couponGet: ->
    id = $(@).closest("tr").data("id")
    $.ajax
      url: Store.context + "/api/admin/coupon/findAllCoupon"
      type: "POST"
      success: (data)->
        that.alert "body", "success", "优惠券同步成功"
        window.setTimeout(
          (->location.href = Store.context + "/mall/coupon"),1500)

module.exports = couponInf
