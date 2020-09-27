Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"
class activity_statistics
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  startpicker = new Pikaday({field: $(".js-date-start")[0]});
  endpicker = new Pikaday({field: $(".js-date-end")[0]});


module.exports = activity_statistics

