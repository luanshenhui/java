Pagination = require "spirit/components/pagination"
Store = require "extras/store"

class businessControl
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  startPicker = null
  endPicker = null
  constructor: ->
#    @$el.find(".datepicker").datepicker()
    startPicker = new Pikaday(
      field:  $(".js-date-start")[0]
      i18n: {
        previousMonth: "����",
        nextMonth: "����",
        months: [ "һ��", "����", "����", "����", "����", "����", "����", "����", "����", "ʮ��", "ʮһ��", "ʮ����" ],
        weekdays: [ "����", "��һ", "�ܶ�", "����", "����", "����", "����" ],
        weekdaysShort: [ "��", "һ", "��", "��", "��", "��", "��" ]
      }
      maxDate: new Date(date)
      onSelect: ->
        startDate = ($(".js-date-start").val()).replace(/-/g,"/")
        endPicker.setMinDate(new Date(startDate))
    )
    endPicker = new Pikaday(
      field: $(".js-date-end")[0]
      i18n: {
        previousMonth: "����",
        nextMonth: "����",
        months: [ "һ��", "����", "����", "����", "����", "����", "����", "����", "����", "ʮ��", "ʮһ��", "ʮ����" ],
        weekdays: [ "����", "��һ", "�ܶ�", "����", "����", "����", "����" ],
        weekdaysShort: [ "��", "һ", "��", "��", "��", "��", "��" ]
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

module.exports = businessControl


