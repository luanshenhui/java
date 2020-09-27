Pagination = require "spirit/components/pagination"
Store = require "extras/store"

class mallRejectGoods
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  startpicker = new Pikaday({field: $(".js-date-start")[0]});
  endpicker = new Pikaday({field: $(".js-date-end")[0]});
  constructor:->

module.exports=mallRejectGoods
