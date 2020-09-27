Pagination = require "spirit/components/pagination"
class Test

  constructor:->
    new Pagination(".pagination").total($(".pagination").data("total")).show()
    @bindEvent()

  bindEvent:->


module.exports = Test