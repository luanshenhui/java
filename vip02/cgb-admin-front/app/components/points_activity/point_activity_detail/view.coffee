Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"
class activity_detail
  new Pagination(".pagination").total($(".pagination").data("total")).show()



module.exports = activity_detail

