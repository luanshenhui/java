Pagination = require "spirit/components/pagination"
Store = require "extras/store"

class pointsRejectDetail
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  startpicker = new Pikaday({field: $(".js-date-start")[0]});
  endpicker = new Pikaday({field: $(".js-date-end")[0]});
  constructor:->
    @bindEvent()
  bindEvent:->
module.exports=pointsRejectDetail