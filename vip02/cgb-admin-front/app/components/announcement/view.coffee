Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"

class announcementManage
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  startpicker = new Pikaday({field: $(".js-date-start")[0]});
  endpicker = new Pikaday({field: $(".js-date-end")[0]});

  constructor: ->
    @announcementNew = ".js-announcement-new"
    @announcementWatch = ".js-announcement-watch"
    @announcementForm = "form.announcement-form"
    @bindEvent()
  announcementNewTemplate = App.templates["announcement_create"]
  announcementWatchTemplate = App.templates["announcement_watch"]
  that = this

  bindEvent: ->
    that = this
    $(@announcementNew).on "click", @newAnnouncement
    $(@announcementWatch).on "click", @watchAnnouncement

  newAnnouncement: ->
    announcementNew = new Modal announcementNewTemplate({})
    announcementNew.show()
    $(that.announcementForm).validator()
    $(that.announcementForm).on "submit", that.createAccount

  createAccount: (evt)->
    evt.preventDefault()
    $.ajax
      url: Store.context + "/api/admin/announcements"
      type: "POST"
      data: $(that.announcementForm).serialize()
      success: (data)->
        window.location.reload()

  watchAnnouncement: ->
    announcementInfo = $(@).closest("tr").data("data")
    announcementWatch = new Modal announcementWatchTemplate(announcementInfo)
    announcementWatch.show()

module.exports = announcementManage
