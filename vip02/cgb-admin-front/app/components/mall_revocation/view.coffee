Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"
class mallRevocation
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  startpicker = new Pikaday({field: $(".js-date-start")[0]});
  endpicker = new Pikaday({field: $(".js-date-end")[0]});
  constructor: ->
    #查看撤单详情
    @revocationDetail = ".js-revocation-detail"

    @bindEvent()
  newReTemplateTemplate = App.templates["revocation_memo"]
  that = this

  bindEvent: ->
    that = this
    $(".mallRevocation").on "click", @revocationDetail, @detailRevocation

  detailRevocation: ->
    data = $(@).closest("tr").data("data")
    component = new Modal newReTemplateTemplate(data)
    component.show()


module.exports = mallRevocation