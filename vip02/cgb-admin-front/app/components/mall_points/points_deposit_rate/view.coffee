Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"

class pointsDepositRate
  constructor: ->
    @pointsDepositForm = "form.points-deposit-form"

    @bindEvent()
  that = this


  bindEvent: ->
    that = this
    $(that.pointsDepositForm).validator
      isErrorOnParent: true
    $(that.pointsDepositForm).on "submit", @submitPointsDepositRate

  submitPointsDepositRate: (evt)->
    evt.preventDefault()
    $(that.pointsDepositForm).validator
      isErrorOnParent: true
    $(".commonCard-required-error").remove() #普卡/金卡
    $(".platinumCard-required-error").remove() #钛金卡/臻享白金卡
    $(".topCard-required-error").remove() #顶级/增值白金卡
    $(".VIP-required-error").remove() #VIP
    $(".birthday-required-error").remove() #生日
    formObject = $("form.points-deposit-form").serializeObject()
    if !/^1(\.0(0){0,1}){0,1}$|^(0\.[0-9]{1,2})$/.test formObject.commonCard #普卡/金卡
      $("#commonCard").parent().append("<span class=\"commonCard-required-error required\"><i>&times;</i>请输入不大于1的两位正小数</span>")
      return
    if !/^1(\.0(0){0,1}){0,1}$|^(0\.[0-9]{1,2})$/.test formObject.platinumCard #钛金卡/臻享白金卡
      $("#platinumCard").parent().append("<span class=\"platinumCard-required-error required\"><i>&times;</i>请输入不大于1的两位正小数</span>")
      return
    if !/^1(\.0(0){0,1}){0,1}$|^(0\.[0-9]{1,2})$/.test formObject.topCard #顶级/增值白金卡
      $("#topCard").parent().append("<span class=\"topCard-required-error required\"><i>&times;</i>请输入不大于1的两位正小数</span>")
      return
    if !/^1(\.0(0){0,1}){0,1}$|^(0\.[0-9]{1,2})$/.test formObject.VIP #VIP
      $("#VIP").parent().append("<span class=\"VIP-required-error required\"><i>&times;</i>请输入不大于1的两位正小数</span>")
      return
    if !/^1(\.0(0){0,1}){0,1}$|^(0\.[0-9]{1,2})$/.test formObject.birthday #生日
      $("#birthday").parent().append("<span class=\"birthday-required-error required\"><i>&times;</i>请输入不大于1的两位正小数</span>")
      return
    $.ajax
      url: Store.context + "/api/admin/pointsBenefit/edit"
      type: "POST"
      data: $("form.points-deposit-form").serializeObject()
      success: (data)->
        new Modal(
          icon: "error"
          title: "温馨提示"
          content: "保存成功"
          overlay: false)
        .show()



module.exports = pointsDepositRate