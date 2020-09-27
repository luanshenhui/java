Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"
class account_request_money
  _.extend @::, TipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  startPicker = null
  endPicker = null
  constructor: ->
    @requestAccept = ".js-request-accept"
    @requestRefuse = ".js-request-refuse"
    @requestAcceptOne = ".js-request-one"
    @selectRequestAll = ".js-select-all"
    @memoForm = ".memo-form"

    startPicker = new Pikaday(
      field:  $(".js-date-start")[0]
      i18n: {
        previousMonth: "上月",
        nextMonth: "下月",
        months: [ "一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月" ],
        weekdays: [ "周日", "周一", "周二", "周三", "周四", "周五", "周六" ],
        weekdaysShort: [ "日", "一", "二", "三", "四", "五", "六" ]
      }
      onSelect: ->
        startDate = ($(".js-date-start").val()).replace(/-/g,"/")
        endPicker.setMinDate(new Date(startDate))
    )
    endPicker = new Pikaday(
      field: $(".js-date-end")[0]
      i18n: {
        previousMonth: "上月",
        nextMonth: "下月",
        months: [ "一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月" ],
        weekdays: [ "周日", "周一", "周二", "周三", "周四", "周五", "周六" ],
        weekdaysShort: [ "日", "一", "二", "三", "四", "五", "六" ]
      }
      onSelect: ->
        endDate = ($(".js-date-end").val()).replace(/-/g,"/")
        startPicker.setMaxDate(new Date(endDate))
    )

    @bindEvent()
  memoTemplate = App.templates["apply_memo"]
  refuseTemplate = App.templates["refuse_memo"]
  that = this

  bindEvent: ->
    that = this
    $(".tab-contents").on "click", @requestAccept, @passRequest
    $(".tab-contents").on "click", @requestRefuse, @refuseRequest
    $(".tab-contents").on "click", @requestAcceptOne, @acceptOneRequest
    $(".tab-contents").on "click", @selectRequestAll, @selectAllRequest

  passRequest: =>
    arr=new Array()
    ids = $(".js-order-check:checkbox:checked")
    if ids.length == 0
      that.alert "body", "error","请选择需要审核的订单！", "请继续其他操作！"
      return
    $.each(ids,(index,item)->
      arr.push(item.value);
    )
    obj = {}
    obj.arr = arr
    obj.sinApplyMemo = null
    obj.orderTypeId="FQ"
    $.ajax
      url: Store.context + "/api/admin/requestMoney/audit-pass"
      type: "POST"
      data: JSON.stringify obj
      contentType:"application/json;charset=utf-8"
      success: (data)->
        window.location.reload()
  refuseRequest: =>
    arr=new Array()
    ids = $(".js-order-check:checkbox:checked")
    if ids.length == 0
      that.alert "body", "error", "请选择需要审核的订单！", "请继续其他操作！"
      return
    $.each(ids,(index,item)->
      arr.push(item.value);
    )
    request_refuse = new Modal refuseTemplate(arr)
    request_refuse.show()
    $(that.memoForm).validator
      isErrorOnParent: true
    $("form.memo-form").on "submit", @refuseMemo
  refuseMemo :(event) ->
    event.preventDefault()
    sinApplyMemo = $("#sinApplyMemo").val()
    arr=$("form.memo-form").data("data")
    obj={}
    obj.arr=arr
    obj.sinApplyMemo=sinApplyMemo
    $.ajax
      url: Store.context + "/api/admin/requestMoney/audit-reject"
      type: "POST"
      data: JSON.stringify obj
      contentType:"application/json;charset=utf-8"
      success: (data)->
        window.location.reload()
  acceptOneRequest: ->
    arr = new Array()
    thisRequest = $(@).closest("tr").data("id")
    arr.push(thisRequest)
    request_pass = new Modal memoTemplate(arr)
    request_pass.show()
    $(that.memoForm).validator
      isErrorOnParent: true
    $("form .js-memo-accept").on "click", that.acceptOneMemo
    $("form.memo-form").on "submit", that.refuseOneRequest
  acceptOneMemo :(event) ->
    event.preventDefault()
    sinApplyMemo = $("#sinApplyMemo").val()
    arr=$("form.memo-form").data("data")
    obj={}
    obj.arr=arr
    obj.sinApplyMemo=sinApplyMemo
    obj.orderTypeId="FQ"
    $.ajax
      url: Store.context + "/api/admin/requestMoney/audit-pass"
      type: "POST"
      data: JSON.stringify obj
      contentType:"application/json;charset=utf-8"
      success: (data)->
        window.location.reload()
  refuseOneRequest: (event) ->
    event.preventDefault()
    sinApplyMemo = $("#sinApplyMemo").val()
    arr=$("form.memo-form").data("data")
    obj={}
    obj.arr=arr
    obj.sinApplyMemo=sinApplyMemo
    $.ajax
      url: Store.context + "/api/admin/requestMoney/audit-reject"
      type: "POST"
      data: JSON.stringify obj
      contentType:"application/json;charset=utf-8"
      success: (data)->
        window.location.reload()

  selectAllRequest : ->
    if $("#selectAll").prop('checked')
      $("input[type='checkbox'].js-order-check").prop('checked',true)
    else
      $("input[type='checkbox'].js-order-check").prop('checked',false)
module.exports = account_request_money