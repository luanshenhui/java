Pagination = require "spirit/components/pagination"
tipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"

class businessControl
  _.extend @::, tipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  startPicker = null
  endPicker = null
  constructor: ->
#    @$el.find(".datepicker").datepicker()
    @jsErrorNotsend = ".js-error-notsend"

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

    @bindEvent()
  that = this
  bindEvent: ->
    that = this
    $(@jsErrorNotsend).on "click", @notsend
    $(document).on "confirm:manual-item", @manual
    $(document).on "confirm:send-item", @send
    $(document).on "confirm:notmanual-item", @notmanual

  notsend:(evt)->
    evt.preventDefault()
    that.alert "body", "error", "提示", "目前是自动模式，如果想手动补发对账文件，请您启用手动模式。"

  manual:(evt, data)->
    evt.preventDefault()
    createDate = data
    $.ajax
      url: Store.context + "/api/admin/MakeCheckJob/onShoudong"
      type: "POST"
      data:  {
        createDateParam: createDate
      }
      success: (data)->
        window.location.reload()
        that.alert "body", "success", "提示", "操作成功"
      error: (data)->
        that.alert "body", "error", "提示", "出错啦"

  send:(evt, data)->
    evt.preventDefault()
    createDate = data
    $.ajax
      url: Store.context + "/api/admin/MakeCheckJob/renew"
      type: "POST"
      data: {
        createDateParam: createDate
      }
      success: (data)->
        window.location.reload()
        that.alert "body", "success", "提示", "操作成功"
      error: (data)->
        that.alert "body", "error", "提示", "出错啦"

  notmanual:(evt, data)->
    evt.preventDefault()
    createDate = data
    $.ajax
      url: Store.context + "/api/admin/MakeCheckJob/onShoudong"
      type: "POST"
      data: {
        createDateParam: createDate
      }
      success: (data)->
        window.location.reload()
        that.alert "body", "success", "提示", "操作成功"
      error: (data)->
        that.alert "body", "error", "提示", "出错啦"

module.exports = businessControl


