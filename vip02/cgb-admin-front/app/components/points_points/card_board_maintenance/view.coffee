Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"

class CardBoardMaintenance
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
    @bindEvent()

  cardBoardTemplate = App.templates["card_board_add_edit"]
  bindEvent:->
    $(".js-card-new").on "click",@addCard
    $(".js-card-edit").on "click",@editCard
    $(document).on "confirm:delete-card",@deleteConfirm
    $(".js-all-check").on "click",@checkAll

  addCard:->
    addModal = new Modal cardBoardTemplate({})
    addModal.show()

  editCard:->
    thisCard = $(@).closest("tr").data("data")
    editModal = new Modal cardBoardTemplate(thisCard)
    editModal.show()

  checkAll:->
    if $(".js-all-check").is(':checked')
      $("input[name='checkCard']").prop("checked",'checked')
    else
      $("input[name='checkCard']").prop("checked",'')


module.exports = CardBoardMaintenance