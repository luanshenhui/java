Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"

class VendorUserAccount
  _.extend @::, TipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
    @change2on = ".js-vendor-change2on"
    @change2off = ".js-vendor-change2off"

    @bindEvent()
  that = this

  bindEvent: ->
    $(".vendorUser").on "click", @change2on, @changeStatus
    $(".vendorUser").on "click", @change2off, @changeStatus
    that = this

  changeStatus: ->
    code = $(@).closest("tr").data("id")
    status = $(@).closest("tr").data("status")
    role = $(@).closest("tr").find(".vendor-role").text()
    if status is "0101"
      if role is ""
        that.alert "body", "error", "该账号未分配角色，请联系供应商后再进行操作！"
        return
      status = "0102"
    else
      status = "0101"
    $.ajax
      url: Store.context + "/api/admin/cooperation/account-changeStatus"
      type: "POST"
      data: {
        status: status
        code: code
      }
      success: (data)=>
        window.location.reload()
      error: (data) ->
        new Modal(
          icon: "error"
          title: "出错啦！"
          content: data.responseText || "未知故障"
          overlay: false)
        .show()



module.exports = VendorUserAccount
