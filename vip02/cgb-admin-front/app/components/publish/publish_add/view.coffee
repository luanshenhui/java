
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"

class publishAdd
  _.extend @::, TipAndAlert
  constructor: ->
    #引入富文本编辑器
    require.async(['/static/umeditor/umeditor.config.js', '/static/umeditor/umeditor.min.js'], (a)->
      um = UM.getEditor('myEditor', {
        zIndex: 99
      });
      um.addListener "ready", ->
        um.setContent(text)
    )
    #表单定义(保存）
    @formPublishSuccess = "form.publish-add-form"
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
    $(that.formPublishSuccess).validator
      isErrorOnParent: true
    $(that.formPublishSuccess).on "submit", @savePublish
#    $(".publishManage").on "click",@publishView,@viewPublish

  setYear: ->
    today = moment()
    nextYear = moment().year(today.year() + 1)
    $(".datepicker").datepicker({
      minDate: new Date(today),
      maxDate: new Date(nextYear),
      yearRange: [today.year(), today.year() + 1]
    })
  #发布公告 保存
  savePublish: (evt)->
    evt.preventDefault()
    $(that.formPublishSuccess).validator
      isErrorOnParent: true
    publishType = $("#publishType").val()
    if publishType is ""
      that.alert "body", "error", "请选择公告类型！"
      return
    #表单序列化
    data = $("form.publish-add-form").serializeObject()
    data.publishContent = UM.getEditor('myEditor').getContent()
    $.ajax
      url: Store.context + "/api/admin/publish/savePublish"
      type: "POST"
      data: data
      success: (data)->
        location.href = Store.context + "/admins/publish/publish_manage"
      error: (e)->
        that.alert "body", "error", "公告发布失败！"

module.exports = publishAdd