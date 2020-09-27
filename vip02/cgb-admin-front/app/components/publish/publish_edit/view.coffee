TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"
class publishEdit
  _.extend @::, TipAndAlert
  constructor: ->
    text = $('.js-introduction').data('value')
    #引入富文本编辑器
    require.async(['/static/umeditor/umeditor.config.js', '/static/umeditor/umeditor.min.js'], (a)->
      um = UM.getEditor('myEditor', {
        zIndex: 99
      });
      um.addListener "ready", ->
        um.setContent(text)
    )
#    @$el.find(".datepicker").datepicker()
    @editPublishForm = "form.publish-edit-form"
    @bindEvent()
    #@setYear()
    startMPicker = new Pikaday(
      field:  $("#publishDate")[0]
      minDate: new Date(moment()),
      i18n: {
        previousMonth: "上月",
        nextMonth: "下月",
        months: [ "一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月" ],
        weekdays: [ "周日", "周一", "周二", "周三", "周四", "周五", "周六" ],
        weekdaysShort: [ "日", "一", "二", "三", "四", "五", "六" ]
      }
      onSelect: ->
        startDate = ($("#publishDate").val()).replace(/-/g,"/")
        endMPicker.setMinDate(new Date(startDate))
    )
    endMPicker = new Pikaday(
      field: $("#expireDate")[0]
      i18n: {
        previousMonth: "上月",
        nextMonth: "下月",
        months: [ "一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月" ],
        weekdays: [ "周日", "周一", "周二", "周三", "周四", "周五", "周六" ],
        weekdaysShort: [ "日", "一", "二", "三", "四", "五", "六" ]
      }
      onSelect: ->
        endDate = ($("#expireDate").val()).replace(/-/g,"/")
        startMPicker.setMaxDate(new Date(endDate))
    )
  that = this

  bindEvent: ->
    that = this
    $(that.editPublishForm).validator
      isErrorOnParent: true
    $(that.editPublishForm).on "submit", @updatePublish


  setYear: ->
    today = moment()
    nextYear = moment().year(today.year() + 1)
    $(".datepicker").datepicker({
      minDate: new Date(today),
      maxDate: new Date(nextYear),
      yearRange: [today.year(), today.year() + 1]
    })

  updatePublish:(evt)->
    evt.preventDefault();
    data=$("form.publish-edit-form").serializeObject()
    data.publishContent =UM.getEditor('myEditor').getContent()
    id = $("form.publish-edit-form").data("id")
    $("form.publish-edit-form").validator
      isErrorOnParent: true
    $.ajax
      url: Store.context + "/api/admin/publish/edit/#{id}"
      type: "POST"
      data: data
      success: (data)->
        window.location.href = Store.context +  "/admins/publish/publish_manage"

module.exports = publishEdit