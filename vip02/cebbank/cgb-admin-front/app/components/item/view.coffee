Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
class item
  new Pagination(".pagination").total($(".pagination").data("total")).show();
  constructor: ->
    @itemNew = ".js-item-new"
    @itemCreate = ".js-item-create"
    @itemEdit = ".js-item-edit"
    @itemUpdate = ".js-item-update"
    @itemDelete=".js-item-delete"
    @bindEvent()
  newItemTemplate = App.templates.item.templates["item_new"]
  itemTemplate = App.templates.item.templates["_item"]
  editItemTemplate = App.templates.item.templates["item_edit"]
  deleteItemTemplate=App.templates.item.templates["item_delete"]
  that = this

  bindEvent: ->
    that = this
    $(".items").on "click", @itemDelete, @deleteItem
    $(".items").on "click", @itemNew, @newItem
    $(".items").on "click", @itemEdit, @editItem

  newItem: =>
    component = new Modal newItemTemplate({})
    component.show()
    $("form.item-form").on "submit", @createItem

  createItem: (evt)->
    evt.preventDefault()
    $.ajax
      url: "/aip/item/create"
      type: "POST"
      data: $("form.item-form").serialize()
      success: (data)->
        window.location.reload()
  editItem: ->
    trData = $(@).closest("tr").find("td")
    component = new Modal editItemTemplate(
      "id": $(trData[0]).html()
      "itemName": $(trData[1]).html()
      "type": $(trData[2]).html()
    )
    component.show()
    $(".js-item-edit").on "click", that.editConfirm
  editConfirm: (event)->
    event.preventDefault()
    $.ajax
      url: "/aip/item/update"
      type: "POST"
      data: $("form.item-form-edit").serialize()
      success: (data)->
        window.location.reload()
  deleteItem: (evt)->
    thisItem= $(@).closest("tr").find("td")
    ready=new Modal deleteItemTemplate({
      id:$(thisItem[0]).html()
    })
    ready.show()
    $(".modal").on  "click",".js-delete-confirm",that.deleteConfirm
  deleteConfirm:(evt)->
    $.ajax
     url:"/aip/item/delete"
     type:"POST"
     data:{id:$(".js-delete-confirm").data("id")}
     success:(data)->
       console.log data
       window.location.reload()

module.exports = item
