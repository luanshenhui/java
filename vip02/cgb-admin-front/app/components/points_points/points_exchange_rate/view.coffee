Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"
class PointsExchange
  new Pagination(".pagination").total($(".pagination").data("total")).show();
  constructor: ->
    @bindEvent()

  rateTemplate = App.templates["rate_add_edit"]
  bindEvent:->
    $(".js-rate-new").on "click",@addRate
    $(".js-rate-edit").on "click",@editRate
    $(document).on "confirm:delete-rate",@deleteConfirm
    $(".js-all-check").on "click", @checkAll

  addRate:->
    addModal = new Modal rateTemplate({})
    addModal.show()

  editRate:->
    thisRate = $(@).closest("tr").data("data")
    editModal = new Modal rateTemplate(thisRate)
    editModal.show()


  checkAll:->
    if $(".js-all-check").is(':checked')
      $("input[name='checkRate']").prop('checked',"checked")
    else
      $("input[name='checkRate']").prop('checked',"")

module.exports = PointsExchange