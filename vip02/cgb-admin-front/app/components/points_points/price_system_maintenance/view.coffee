Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"

class PriceSystemMaintenance
  new Pagination(".pagination").total($(".pagination").data("total")).show();
  constructor: ->
    @bindEvent()

  goldCardTemplate = App.templates['goldCard']
  otherCardTemplate = App.templates['otherCard']
  bindEvent:->
    $(".js-gold-add").on "click",@addGoldCardParams
    $(".js-gold-edit").on "click",@editGoldCardParams
    $(document).on "confirm:gold-delete",@deleteGoldConfirm
    $(".js-other-add").on "click",@addOtherCardParams
    $(".js-other-edit").on "click",@editOtherCardParams
    $(document).on "confirm:other-delete",@deleteGoldConfirm
    $(".js-tab-li-first").on "click",@firstTab
    $(".js-tab-li-secend").on "click",@secendTab
    $(".js-gold-all-check").on "click",@checkAllGold
    $(".js-other-all-check").on "click",@checkAllOther

  addGoldCardParams:->
    addGoldModal = new Modal goldCardTemplate({})
    addGoldModal.show()

  editGoldCardParams:->
    thisGold = $(@).closest("tr").data("data")
    editGoldModal = new Modal goldCardTemplate(thisGold)
    editGoldModal.show()

  addOtherCardParams:->
    addOtherModal = new Modal otherCardTemplate({})
    addOtherModal.show()

  editOtherCardParams:->
    thisOther = $(@).closest("tr").data("data")
    editOtherModal = new Modal otherCardTemplate(thisOther)
    editOtherModal.show()

  firstTab:->
    $(".js-tab-second").hide()
    $(".js-tab-first").show()

  secendTab:->
    $(".js-tab-first").hide()
    $(".js-tab-second").show()

  checkAllGold:->
    if $(".js-gold-all-check").is(':checked')
      $("input[name='checkGold']").prop("checked",'checked')
    else
      $("input[name='checkGold']").prop("checked",'')

  checkAllOther:->
    if $(".js-other-all-check").is(':checked')
      $("input[name='checkOther']").prop("checked",'checked')
    else
      $("input[name='checkOther']").prop("checked",'')


module.exports = PriceSystemMaintenance