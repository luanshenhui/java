Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"


class PointsVendorUserAccount
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
    @change2on = ".js-vendor-change2on"
    @change2off = ".js-vendor-change2off"

    @bindEvent()
  that = this

  bindEvent: ->
    $(".pointsVendorUser").on "click", @change2on, @changeStatus
    $(".pointsVendorUser").on "click", @change2off, @changeStatus
    that = this

  changeStatus: ->
    code = $(@).closest("tr").data("id")
    status = $(@).closest("tr").data("status")
    if status is "0101"
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



module.exports = PointsVendorUserAccount
