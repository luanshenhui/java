Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"

class ItemAudit
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  startPicker = null
  endPicker = null
  constructor: ->
    @itemAuditDetailButton = $('.js-item-audit-detail')
    @itemAuditAuditButton = $('.js-item-audit-audit')

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
    #绑定事件
    @bindEvent()

  bindEvent:->
    @itemAuditDetailButton.on 'click', @itemAuditDetail
    @itemAuditAuditButton.on 'click', @itemAuditAudit

  itemAuditDetail:->
    id = $(@).closest("tr").data("id")
    window.location.href = Store.context + "/mall/activity/item-audit-detail?promotionId="+id+"&type=detail"

  itemAuditAudit:->
    id = $(@).closest("tr").data("id")
    window.location.href = Store.context + "/mall/activity/item-audit-detail?promotionId="+id+"&type=audit"

module.exports = ItemAudit