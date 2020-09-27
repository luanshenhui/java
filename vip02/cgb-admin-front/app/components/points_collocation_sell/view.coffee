Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"

class collocationSellPoints
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
    @collocationEdit = ".js-collocation-edit"
#查看订单详情
    @orderInfo = ".js-order-info"
    #审核
    @orderInfo = ".js-collocation-examine"
    @bindEvent()
  newCollocationTemplate = App.templates["point_collocation_new"]
  that = this

  bindEvent: ->
    that = this
    $(document).on "click", @collocationEdit, @editCollocation
    $(".js-tab-li-first").on "click", @firstTab
    $(".js-tab-li-secend").on "click", @secendTab
    $(".js-other-all-check").on "click", @checkAllOther
    $(document).on "confirm:delete-collocation", @deleteAll
    $(".collocationSellPoints").on "click",@orderInfo, @infoOrder
  infoOrder: ->
    location.href = Store.context + "orderInfo"

  editCollocation: ->
    data = $(@).closest("tr").data("data")
    component = new Modal(newCollocationTemplate(data)).show()
    $(".collocation-form").validator()

  firstTab: ->
    $(".js-tab-second").hide()
    $(".js-tab-first").show()

  secendTab: ->
    $(".js-tab-first").hide()
    $(".js-tab-second").show()

  checkAllOther: ->
    if $(".js-other-all-check").is(':checked')
      $("input[name='checkOther']").prop("checked", 'checked')
    else
      $("input[name='checkOther']").prop("checked", '')

  deleteAll: (evt, data)->
    alert "aaa"
    $.ajax
      url: Store.context + "/api/admin/collocation/" + data
      type: "DELETE"
      dataType: "JSON"
    success: (data)->
      $("tr[data-id=#{id}]").remove()
      window.location.reload()
module.exports = collocationSellPoints

