Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"

vendorImportResult = App.templates['points_vendors_import_result']
vendorUploadTemp = App.templates["points_vendor_upload"]
class PointsCooperation
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
    @cooperationNew = ".js-cooperation-add"
    @$cooperationImport = $(".js-cooperation-import")
    @cooperationEdit = ".js-cooperation-edit"
    @cooperationCheck = ".js-cooperation-check"
    @cooperationView = ".js-cooperation-view"
    @cooperationAccount = ".js-cooperation-account"


    @bindEvent()
  that = this

  bindEvent: ->
    $(".points-cooperation").on "click", @cooperationNew, @newCooperation
    @$cooperationImport.on "click", @importCooperation
    $(".points-cooperation").on "click", @cooperationEdit, @editCooperation
    $(".points-cooperation").on "click", @cooperationCheck, @checkCooperation
    $(".points-cooperation").on "click", @cooperationView, @viewCooperation
    $(".points-cooperation").on "click", @cooperationAccount, @vendorUserAccount
    $(document).on "confirm:delete-cooperation",  @deleteCooperation
    that = this

  newCooperation: ->
    window.location.href = Store.context + "/points/cooperation/cooperation_add";

#批量导入开始
  importCooperation: ->
    new Modal(vendorUploadTemp(context:Store.context)).show()

  uploadImportFile:(evt)->
    file = $(that.uploadImportFileBtn).val()
    if file isnt ""
      resValArray = file.split('\\')
      $(".file-input").val(resValArray[resValArray.length-1])
    else
      $(".file-input").val(file)


  editCooperation: ->
    vendorId = $(@).closest("tr").data("id")
    window.location.href = Store.context + "/points/cooperation/cooperation_edit?vendorId=" + vendorId;
  checkCooperation: ->
    vendorId = $(@).closest("tr").data("id")
    window.location.href = Store.context + "/points/cooperation/cooperation_detail?flag=0&vendorId=" + vendorId;
  viewCooperation: ->
    vendorId = $(@).closest("tr").data("id")
    window.location.href = Store.context + "/points/cooperation/cooperation_detail?vendorId=" + vendorId;
  deleteCooperation: (evt, data)->
    componentId = data
    $.ajax
      url: Store.context + "/api/admin/cooperation/delete"
      type: "POST"
      data: {
        vendorId: componentId
      }
      success: (data)=>
        $("tr[data-id=#{componentId}]").remove()
        window.location.href = Store.context + "/points/cooperation/cooperation_all"

  vendorUserAccount:->
    vendorId = $(@).closest("tr").data("id")
    window.location.href = Store.context + "/points/cooperation/vendorUser_account?vendorId="+ vendorId;

module.exports = PointsCooperation
