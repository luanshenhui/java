Modal = require "spirit/components/modal"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"

class pointsOrderManage
  _.extend @::, TipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  startPicker = null
  endPicker = null
  orderTimer = null

  constructor: ->
    @orderTrans = ".js-orderManage-trans"
    @orderRevoke = ".js-orderManage-revoke"
    @orderReturn = ".js-orderManage-orderReturn"
    @orderReset = ".js-order-reset"
    @transFollow = ".js-order-transFollow"
    @searchBtn = ".js-btn-search"

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
    @setQueryDate()
    @startOrderExportTime()
  that = this
  orderTransTemplate = App.templates["points_order_trans"]
  returnDetailTemplate = App.templates["points_order_return"]

  bindEvent: ->
    that = this
    $(@orderReset).on "click", @reset
    $(".pointsOrder_manage").on "click", @orderTrans, @transWatch
    $(".pointsOrder_manage").on "click", @orderRevoke, @revokeWatch
    $(".pointsOrder_manage").on "click", @orderReturn, @returnOrder
    $(".pointsOrder_manage").on "click", ".js-batchOutOrder", @exportOrder
    $(document).on "click", ".js-OutOrder-download", @downloadOrderExcel
    $(document).on "click", @searchBtn, @exportOrder
    $(document).on "click", @transFollow, @queryLogisticsUrl
    $(document).on "click", "#checkbox", @clearDate
    @setYear()
    @getOrderExportUrl()

  clearDate: ->
    if $("#checkbox").is ":checked"
      $(".js-date-start").val('')
      $(".js-date-end").val('')

  setQueryDate: ->
    searchType = $(".search-type").val()
    if $.trim(searchType).length==0
      today = new Date()
      startDate = new Date(today.getTime()-30*24*3600*1000)
      startTime = moment(startDate.getTime()).format('YYYY-MM-DD')
      endTime = moment(today.getTime()).format('YYYY-MM-DD')
      $(".js-date-start").val(startTime)
      $(".js-date-end").val(endTime)
      $(".search-type").val('1')

  returnOrder: (event)->
    event.preventDefault()
    id = $(@).closest("tr").data("id")
    $.ajax
      url: Store.context + "/api/admin/PointsOrderManage/watchRevoke"
      type: "GET"
      data: {
        orderId: id
      }
      success: (data)->
        returnDetail = new Modal returnDetailTemplate(data.data)
        returnDetail.show()
        $(".js-check-lastChild li:last-child").css("position","relative")
        $(".js-check-lastChild li:last-child").append('<span class="afterLine">' + '</span>')

  transWatch: (event)->
    event.preventDefault()
    id = $(@).closest("tr").data("id")
    $.ajax
      url: Store.context + "/api/admin/PointsOrderManage/watchTrans"
      type: "GET"
      data: {
        orderId: id
      }
      success: (data)->
        data.data.flag = true
        data.data.url = $(".main-box-table").data("url");
        trans = new Modal orderTransTemplate(data.data)
        trans.show()

  revokeWatch: (event)->
    event.preventDefault()
    id = $(@).closest("tr").data("id")
    $.ajax
      url: Store.context + "/api/admin/PointsOrderManage/watchRevoke"
      type: "GET"
      data: {
        orderId: id
      }
      success: (data)->
        data.data.flag = false
        revoke = new Modal orderTransTemplate(data.data)
        revoke.show()

  reset: ->
    window.location.reload()

  queryLogisticsUrl: (event)->
    $.ajax
      url: Store.context + "/api/admin/PointsOrderManage/queryLogisticsUrl"
      success: (data)->
        window.open(data)


  setYear: ->
    today = new Date()
    year = today.getFullYear()
    month = today.getMonth() + 1
    day = today.getDate()
    date = [year, month, day].join("-")
    $(".datepicker").datepicker({maxDate: new Date(date), yearRange: [1984, year]})

#批量导出
  exportOrder: (event) ->
    event.preventDefault()
    id = $(@).attr("id")
    if id is "2"
      $.ajax
        url: Store.context + "/api/admin/OrderManage/exportOrderUndelivered"
        type: "POST"
        data: orders : JSON.stringify $("form.pointsOrder-search-form").serializeObject()
        success: (data)->
          that.getOrderExportUrl()
          that.startOrderExportTime()
        error: ->
          that.getOrderExportUrl()
          that.startOrderExportTime()
    else
      searchAction = window.location.href
      searchAction = searchAction.split("?")[0]
      $(".pointsOrder-search-form").attr("method", "GET")
      $(".pointsOrder-search-form").attr("action", searchAction)
      $("form.pointsOrder-search-form").submit()

## 检查下单日期是否合法
  checkDate:->
    startTime = $("#startTime").val()
    endTime = $("#endTime").val()
    if startTime is "" or startTime is null
      that.tip $("#startTime").parent(), "error", "up", "请输入下单开始时间！"
      $(".tip").css("left", 10).css("top", 41)
      return false
    if endTime is "" or endTime is null
      that.tip $("#endTime").parent(), "error", "up", "请输入下单结束时间！"
      $(".tip").css("left", 10).css("top", 41)
      return false
    endMills = new Date(endTime.replace(/-/g, "/")).valueOf() ## 下单结束日期 毫秒值
    startMills = new Date(startTime.replace(/-/g, "/")).valueOf() ## 下单开始日期 毫秒值
    midMills = (31) * 24 * 60 * 60 * 1000 ## 间隔的时间 毫秒值
    if endMills < startMills
      that.tip $("#endTime").parent(), "error", "up", "下单结束日期不能小于开始日期！"
      $(".tip").css("left", 10).css("top", 41)
      return false
    if midMills < (endMills - startMills)
      that.tip $("#endTime").parent(), "error", "up", "下日期间隔时间不能超过31天！"
      $(".tip").css("left", 10).css("top", 41)
      return false
    return true


#开始导出时调用查询
  startOrderExportTime: ->
    orderTimer = setInterval (->
      that.getOrderExportUrl()
    ), 5000

  getOrderExportUrl: ->
    $(".js-OutOrder-download").hide()
    $(".js-batchOutOrder").show()
    $.ajax
      url: Store.context + "/api/admin/OrderManage/getUserOrderExport"
      type: "GET"
      data: orderTypeId : "JF"
      success: (data)->
        response = data.data
        if response == "00" #没有生成记录
          $(".outOrder-state").hide()
          $(".outOrder-state").html("没有生成记录")
          clearInterval(orderTimer)
          return
        if response == "99" #查询出错
          $(".outOrder-state").hide()
          $(".outOrder-state").html("查询出错")
          clearInterval(orderTimer)
          return
        if response == "98" #生成出错
          $(".outOrder-state").show()
          $(".outOrder-state").html("生成出错")
          clearInterval(orderTimer)
          return
        if response == "97" #生成出错
          $(".outOrder-state").show()
          $(".outOrder-state").html("订单数量超过100000件,请修改查询条件")
          clearInterval(orderTimer)
          return
        if response == "01" #生成中
          $(".outOrder-state").show()
          $(".outOrder-state").html("生成中")
          $(".js-batchOutOrder").hide()
          return
        if response.indexOf("end") < 0 #生成中
          $(".outOrder-state").show()
          $(".outOrder-state").html("生成中")
          $(".js-batchOutOrder").hide()
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
        exname = response.split("--")
        names = exname[1].split(",")
        $(".outorder-download").empty()
        namesl = names.length
        _.each names,(name,i)->
          exbutton = "<button class=\"btn btn-info btn-small js-OutOrder-download\" data=\"" + exname[0] + names[namesl-i-1] + "\"> 下载" + "_" + (i+1) + "</button>"
          $(".outorder-download").append(exbutton)
        $(".js-OutOrder-download").show()
      error:->
        $(".outOrder-state").show()
        $(".outOrder-state").html("查询出错")
        clearInterval(orderTimer)

  downloadOrderExcel: ->
    url = Store.context+"/api/admin/report/excel?fileUrl="+$(@).attr("data")
    window.open(url, '_blank');

module.exports = pointsOrderManage
