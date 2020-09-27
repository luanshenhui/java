Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"


class account_request_money
  _.extend @::, TipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  startPicker = null
  endPicker = null
  orderTimer = null
  constructor: ->
    @requestAccept = ".js-request-accept"
    @requestRefuse = ".js-request-refuse"
    @requestAcceptOne = ".js-request-one"
    @selectRequestAll = ".js-select-all"
    @memoForm = ".memo-form"
    @search = ".js-search-button"

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
    @startOrderExportTime()
    @getOrderExportUrl()
  memoTemplate = App.templates["apply_memo"]
  refuseTemplate = App.templates["refuse_memo"]
  searchAction = null
  that = this

  bindEvent: ->
    that = this
    $(".tab-contents").on "click", @requestAccept, @passRequest
    $(".tab-contents").on "click", @requestRefuse, @refuseRequest
    $(".tab-contents").on "click", @requestAcceptOne, @acceptOneRequest
    $(".tab-contents").on "click", @selectRequestAll, @selectAllRequest
    $(document).on "click", ".js-OutOrder-download", @downloadOrderExcel
    $(document).on "confirm:export-order", @exportRequest
    $(document).on "click", @search, @exportRequest

  passRequest: =>
    arr = new Array()
    ids = $(".js-order-check:checkbox:checked")
    if ids.length == 0
      that.alert "body", "error", "请至少选择一条记录！"
      return
    $.each(ids, (index, item)->
      arr.push(String(item.value));
    )
    obj = {}
    obj.arr = arr
    obj.sinApplyMemo = null
    obj.orderTypeId="JF"
    $.ajax
      url: Store.context + "/api/admin/requestMoney/audit-pass"
      type: "POST"
      data: JSON.stringify obj
      contentType: "application/json;charset=utf-8"
      success: (data)->
        window.location.reload()
  exportRequest: (event,data)=>
    event.preventDefault()
    if data is "2"
      $.ajax
        url: Store.context + "/api/admin/requestMoney/exportAll"
        type: "POST"
        data: conditionDto : JSON.stringify $("form.js-request-form").serializeObject()
        success: (data)->
          that.getOrderExportUrl()
          that.startOrderExportTime()
        error: ->
          that.getOrderExportUrl()
          that.startOrderExportTime()
    else
      searchAction = window.location.href
      searchAction = searchAction.split("?")[0]
      $(".js-request-form").attr("method", "GET")
      $(".js-request-form").attr("action", searchAction)
      $("form.js-request-form").submit()
  refuseRequest: =>
    arr = new Array()
    ids = $(".js-order-check:checkbox:checked")
    if ids.length == 0
      that.alert "body", "error", "请至少选择一条记录！"
      return
    $.each(ids, (index, item)->
      arr.push(String(item.value));
    )
    request_refuse = new Modal refuseTemplate(arr)
    request_refuse.show()
    $(that.memoForm).validator
      isErrorOnParent: true
    $("form.memo-form").on "submit", @refuseMemo
  refuseMemo: (event) ->
    event.preventDefault()
    sinApplyMemo = $("#sinApplyMemo").val()
    arr = $("form.memo-form").data("data")
    obj = {}
    obj.arr = arr
    obj.sinApplyMemo = sinApplyMemo
    $.ajax
      url: Store.context + "/api/admin/requestMoney/audit-reject"
      type: "POST"
      data: JSON.stringify obj
      contentType: "application/json;charset=utf-8"
      success: (data)->
        window.location.reload()
  acceptOneRequest: ->
    arr = new Array()
    thisRequest = String($(@).closest("tr").data("id"))
    arr.push(thisRequest)
    request_pass = new Modal memoTemplate(arr)
    request_pass.show()
    $(that.memoForm).validator
      isErrorOnParent: true
    $("form .js-memo-accept").on "click", that.acceptOneMemo
    $("form.memo-form").on "submit", that.refuseOneRequest
  acceptOneMemo: (event) ->
    event.preventDefault()
    sinApplyMemo = $("#sinApplyMemo").val()
    arr = $("form.memo-form").data("data")
    obj = {}
    obj.arr = arr
    obj.sinApplyMemo = sinApplyMemo
    obj.orderTypeId="JF"
    $.ajax
      url: Store.context + "/api/admin/requestMoney/audit-pass"
      type: "POST"
      data: JSON.stringify obj
      contentType: "application/json;charset=utf-8"
      success: (data)->
        window.location.reload()
  refuseOneRequest: (event) ->
    event.preventDefault()
    sinApplyMemo = $("#sinApplyMemo").val()
    arr = $("form.memo-form").data("data")
    obj = {}
    obj.arr = arr
    obj.sinApplyMemo = sinApplyMemo
    $.ajax
      url: Store.context + "/api/admin/requestMoney/audit-reject"
      type: "POST"
      data: JSON.stringify obj
      contentType: "application/json;charset=utf-8"
      success: (data)->
        window.location.reload()

  selectAllRequest: ->
    if $("#selectAll").prop('checked')
      $("input[type='checkbox']").prop('checked', true)
    else
      $("input[type='checkbox']").prop('checked', false)

  #检验输入时间正确性
  checkDate:->
    startTime =  $("#startTime").val()
    endTime =  $("#endTime").val()
    if startTime is "" or startTime is null
      that.tip $("#startTime").parent(), "error", "up", "请输入下单开始时间！"
      $(".tip").css("left", 10).css("top", 41)
      return false
    if endTime is "" or endTime is null
      that.tip $("#endTime").parent(), "error", "up", "请输入下单结束时间！"
      $(".tip").css("left", 10).css("top", 41)
      return false
    endMills = new Date(endTime).valueOf() ## 下单结束日期 毫秒值
    startMills = new Date(startTime).valueOf() ## 下单开始日期 毫秒值
    if endMills < startMills
      that.tip $("#endTime").parent(), "error", "up", "下单结束日期不能小于开始日期！"
      $(".tip").css("left", 10).css("top", 41)
      return false
    return true
#开始导出时调用查询
  startOrderExportTime: ->
    orderTimer = setInterval (->
      that.getOrderExportUrl()
    ), 5000
  getOrderExportUrl: ->
    $.ajax
      url: Store.context + "/api/admin/requestMoney/findAskExport"
      type: "POST"
      success: (data)->
        response = data.data
        if response == "00" #没有生成记录
          $(".outOrder-state").hide()
          $(".outOrder-state").html("没有生成记录")
          $(".js-request-export").show()
          $(".js-OutOrder-download").hide()
          clearInterval(orderTimer)
          return
        if response == "99" #查询出错
          $(".outOrder-state").hide()
          $(".outOrder-state").html("查询出错")
          $(".js-request-export").show()
          $(".js-OutOrder-download").hide()
          clearInterval(orderTimer)
          return
        if response == "98" #生成出错
          $(".outOrder-state").show()
          $(".outOrder-state").html("生成出错")
          $(".js-request-export").show()
          $(".js-OutOrder-download").hide()
          clearInterval(orderTimer)
          return
        if response == "97" #生成出错
          $(".outOrder-state").show()
          $(".outOrder-state").html("订单数量超过100000件,请修改查询条件")
          $(".js-request-export").show()
          $(".js-OutOrder-download").hide()
          clearInterval(orderTimer)
          return
        if response == "01" #生成中
          $(".outOrder-state").show()
          $(".outOrder-state").html("生成中")
          $(".js-request-export").hide()
          $(".js-OutOrder-download").hide()
          return
        if response.indexOf("end") < 0 #生成中
          $(".outOrder-state").show()
          $(".outOrder-state").html("生成中")
          $(".js-request-export").hide()
          $(".js-OutOrder-download").hide()
          exname = response.split("--")
          names = exname[1].split(",")
          $(".outorder-download").empty()
          namesl = names.length
          _.each names,(name,i)->
            exbutton = "<button class=\"btn btn-info btn-small js-OutOrder-download\" data=\"" + exname[0] + names[namesl-i-1] + "\"> 下载" + "_" + (i+1) + "</button>"
            $(".outorder-download").append(exbutton)
          $(".js-OutOrder-download").show()
          return
        clearInterval(orderTimer)
        $(".outOrder-state").show()
        $(".outOrder-state").html("生成成功")
        $(".js-request-export").show()
        exname = response.split("--")
        names = exname[1].split(",")
        $(".outorder-download").empty()
        namesl = names.length
        _.each names,(name,i)->
          exbutton = "<button class=\"btn btn-info btn-small js-OutOrder-download\" data=\"" + exname[0] + names[namesl-i-1] + "\"> 下载" + "_" + (i+1) + "</button>"
          $(".outorder-download").append(exbutton)
        $(".js-OutOrder-download").show()
#that.downloadOrderExcel()
      error:->
        $(".outOrder-state").show()
        $(".outOrder-state").html("查询出错")
        clearInterval(orderTimer)
        
  downloadOrderExcel: ->
    url = Store.context+"/api/admin/report/excel?fileUrl="+$(@).attr("data")
    window.open(url, '_blank');

module.exports = account_request_money