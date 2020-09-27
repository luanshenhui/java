Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"

class activity
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  startPicker = null
  endPicker = null
  constructor: ->
    @jsAll = ".js-all-check"
#    @$el.find(".datepicker").datepicker()
    @activityDetailButton = $('.js-activity-detail')
    @activityStatisticsButton = $('.js-activity_statistics')
    @activityEditButton = $('.js-activity_edit')
    @activityDeleteButton = $('.js-activity-delete')
    @activityTotalButton = $('.js-activity-total')

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

  bindEvent: ->
    $(@jsAll).on "click", @checkAll
    $(document).on "confirm:delete-activity",  @deleteActivity
    $(document).on "confirm:rollDown-activity",  @rollDownActivity

    @activityDetailButton.on 'click', @activityDetail
    @activityStatisticsButton.on 'click', @activityStatistics
    @activityEditButton.on 'click', @activityEdit
    @activityTotalButton.on 'click',@activityTotal
    $(".prom-search-btn").on "click",@promSearchFn

  activityDetail:->
    id = $(@).closest("tr").data("id")
    window.location.href = Store.context + "/mall/activity/activity-detail?promotionId="+id

  activityStatistics:->
    id = $(@).closest("tr").data("id")
    window.location.href = Store.context + "/mall/activity/activity_statistics?id="+id

  activityEdit:->
    id = $(@).closest("tr").data("id")
    window.location.href = Store.context + "/mall/activity/activity_edit?promotionId="+id

  activityTotal: ->
    id = $(@).closest("tr").data("id")
    window.location.href = Store.context + "/mall/activity/activity_statistics?promId="+id

  checkAll: ->
    if $(".js-all-check").is(':checked')
      $("input[type='checkbox']").prop('checked', "checked")
    else
      $("input[type='checkbox']").prop('checked', "")

  #删除
  deleteActivity: (evt, data)->
    $.ajax
      url: Store.context + "/api/admin/promotion/offAndDelete"
      type: "POST"
      data: {
        'promotionId': data,
        'checkStatus': 13
      }
      success: (data)=>
        window.location.reload()

  #下线
  rollDownActivity: (evt, data)->
    $.ajax
      url: Store.context + "/api/admin/promotion/offLine "
      type: "POST"
      data: {
        'promotionId': data,
        'checkStatus': 11
      }
      success: (data)=>
        window.location.reload()
  promSearchFn:(evt)->
    $(".promotion-search-form").submit()

module.exports = activity

