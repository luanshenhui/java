Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"

class keywordSearch
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  startPicker = null
  endPicker = null
  constructor: ->
    @firm = ".firm"
    @orderType = ".js-keyword-orderType"
    @bindEvent()
    @typeChange()

  that = this

  bindEvent: ->
    that = this
    $(@firm).on "change", @orderType, @typeChange
    @setYear()

  typeChange: ->
    ordertypeId = $("#ordertypeId").val()
    sourceId = $("#sourceIdVal").val()

    if ordertypeId == "jf"
      if sourceId==""
        s = "<option value=''>请选择</option>"
      else
        s = "<option value='' selected>请选择</option>"
      if sourceId=="08"
        s += "<option selected value=" + "08" +">积分商城</option>"
      else
        s += "<option value=" + "08" +">积分商城</option>"
      if sourceId=="03"
        s += "<option selected value=" + "03" +">手机商城</option>"
      else
        s += "<option value=" + "03" +">手机商城</option>"
      if sourceId=="01"
        s += "<option selected value=" + "01" +">CallCenter</option>"
      else
        s += "<option value=" + "01" +">CallCenter</option>"
      if sourceId=="02"
        s += "<option selected value=" + "02" +">IVR</option>"
      else
        s += "<option value=" + "02" +">IVR</option>"
      if sourceId=="04"
        s += "<option selected value=" + "04" +">短信</option>"
      else
        s += "<option value=" + "04" +">短信</option>"
      $("#sourceId").html(s)
    else
      if sourceId==""
        s = "<option value=''>请选择</option>"
      else
        s = "<option value='' selected>请选择</option>"
      if sourceId=="00"
        s += "<option selected value=" + "00" +">广发商城</option>"
      else
        s += "<option value=" + "00" +">广发商城</option>"
      if sourceId=="03"
        s += "<option selected value=" + "03" + ">手机商城</option>"
      else
        s += "<option value=" + "03" + ">手机商城</option>"
      if sourceId=="01"
        s += "<option selected value=" + "01" + ">CallCenter</option>"
      else
        s += "<option value=" + "01" + ">CallCenter</option>"
      if sourceId=="04"
        s += "<option selected value=" + "04" + ">短信</option>"
      else
        s += "<option value=" + "04" + ">短信</option>"
      if sourceId=="05"
        s += "<option selected value=" + "05" + ">微信广发银行</option>"
      else
        s += "<option value=" + "05" + ">微信广发银行</option>"
      if sourceId=="06"
        s += "<option selected value=" + "06" + ">微信广发信用卡</option>"
      else
        s += "<option value=" + "06" + ">微信广发信用卡</option>"
      if sourceId=="09"
        s += "<option selected value=" + "09" + ">APP</option>"
      else
        s += "<option value=" + "09" + ">APP</option>"
      $("#sourceId").html(s)




  setYear: ->
    today = new Date()
    year = today.getFullYear()
    month = today.getMonth() + 1
    day = today.getDate()
    date = [year, month, day].join("-")
    $(".datepicker").datepicker({format:"YYYY-MM-DD HH:mm:ss",maxDate: new Date(date), yearRange: [1984, year]})

    startPicker = new Pikaday(
      field:  $(".js-date-start")[0]
      i18n: {
        previousMonth: "上月",
        nextMonth: "下月",
        months: [ "一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月" ],
        weekdays: [ "周日", "周一", "周二", "周三", "周四", "周五", "周六" ],
        weekdaysShort: [ "日", "一", "二", "三", "四", "五", "六" ]
      }
      maxDate: new Date(date)
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
      maxDate: new Date(date)
      onSelect: ->
        endDate = ($(".js-date-end").val()).replace(/-/g,"/")
        startPicker.setMaxDate(new Date(endDate))
    )

module.exports = keywordSearch

