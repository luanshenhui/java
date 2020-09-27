Modal = require "spirit/components/modal"
Store = require "extras/store"
TipAndAlert = require "tip_and_alert/tip_and_alert"
class tradeSetting
  _.extend @::, TipAndAlert

  constructor: ->
    @switchEdit = ".js-setting-save"
    @bindEvent()
  that = this
  bindEvent: ->
    that = this
    $(".tradeSettings").on "click", @switchEdit, @save

  save: (evt)->
    evt.preventDefault()
    obj = $("form.setting-form").serializeObject()
    #支付开关ID
    obj.tradeId = $("#tradeOpen").data("id")
    $.ajax
      url: Store.context + "/api/admin/tradeSetting/switch"
      type: "POST"
      data: obj
      success: (data)->
        that.alert "body", "success", "保存成功！", "请继续其他操作！"

module.exports = tradeSetting
