Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"

class item_review
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  #  startpicker = new Pikaday({field: $(".js-date-start")[0]});
  #  endpicker = new Pikaday({field: $(".js-date-end")[0]});
  #  startpicker = new Pikaday({field: $(".js-date-start1")[0]});
  #  endpicker = new Pikaday({field: $(".js-date-end1")[0]});

  startPicker = null
  endPicker = null

  constructor: ->
    require.async(['/static/umeditor/umeditor.config.js','/static/umeditor/umeditor.min.js'],(a)->
      um = UM.getEditor('myEditor', {
        zIndex: 99
      });
    )
    #    @$el.find(".datepicker").datepicker()

    @itemReviewJoinedButton = $('.js-item-review-joined')
    @itemReviewNotJoinedButton = $('.js-item-review-not-joined')
    @itemReviewDetailButton = $('.js-item-review-detail')

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

  that = this

  bindEvent: ->
    that = this
    @itemReviewJoinedButton.on 'click', @itemReviewJoined
    @itemReviewNotJoinedButton.on 'click', @itemReviewNotJoined
    @itemReviewDetailButton.on 'click', @itemReviewDetail

  itemReviewJoined:->
    id = $(@).closest("tr").data("id")
    window.location.href = Store.context + "/mall/activity/item-review-detail?promotionId="+id+"&type=review&isJoined=1"

  itemReviewNotJoined:->
    id = $(@).closest("tr").data("id")
    window.location.href = Store.context + "/mall/activity/item-review-detail?promotionId="+id+"&type=review&isJoined=0"

  itemReviewDetail:->
    id = $(@).closest("tr").data("id")
    window.location.href = Store.context + "/mall/activity/item-review-detail?promotionId="+id+"&type=detail"

module.exports = item_review

