Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"

class componentConfig
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
    @componentNew = ".js-component-new"
    @componentCreate = ".js-component-create"
    @componentEdit = ".js-component-edit"
    @componentUpdate = ".js-component-update"
    @componentForm = ".component-form"
    @bindEvent()
  componentTemplate = App.templates.config.templates.component_new
  componentItemTemplate = App.templates.config.templates["_component_item"]
  that = this

  bindEvent: ->
    that = this
    $(document).on "confirm:delete-component", @deleteComponent
    $(".components").on "click", @componentNew, @newComponent
    $(".components").on "click", @componentEdit, @editComponent

  newComponent: =>
    component = new Modal componentTemplate({})
    component.show()
    $(that.componentForm).validator
      isErrorOnParent: true
    $("form.component-form").on "submit", that.createComponent

  createComponent: (evt)->
    evt.preventDefault()
    $("body").spin("big")
    $(that.componentForm).validator
      isErrorOnParent: true
    $.ajax
      url: Store.context + "/api/admin/components"
      type: "POST"
      data: $("form.component-form").serialize()
      success: (data)->
        window.location.reload()

  editComponent: ->
    trData = $(@).closest("tr").find("td")
    component = new Modal componentTemplate(
      "id": $(trData[0]).html()
      "componentCategory": $(trData[1]).html()
      "name": $(trData[2]).html()
      "description": $(trData[3]).html()
      "path": $(trData[4]).html()
      "api": $(trData[5]).html()
    )
    $("form.component-form").attr "component-id", $(trData[0]).html()
    component.show()
    $(".component-form").validator()
    $("form.component-form").on "submit", that.updateComponent
  updateComponent: (evt)->
    evt.preventDefault()
    componentId = $("form.component-form").attr "component-id"
    $.ajax
      url: Store.context + "/api/admin/components/" + componentId
      type: "PUT"
      data: $("form.component-form").serialize()
      success: =>
        window.location.reload()

  deleteComponent: (evt, data)->
    componentId = data
    $.ajax
      url: Store.context + "/api/admin/components/#{componentId}"
      type: "DELETE"
      dataType: "JSON"
      success: (data)=>
        $("tr[data-id=#{componentId}]").remove()
      error: (e)->
module.exports = componentConfig
