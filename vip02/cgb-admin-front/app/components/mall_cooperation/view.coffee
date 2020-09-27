Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"
tipAndAlert = require "tip_and_alert/tip_and_alert"

vendorImportResult = App.templates['vendors_import_result']
vendorDownloadTemp = App.templates["vendor_download"]
class MallCooperation
  _.extend @::, tipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
    @cooperationNew = ".js-cooperation-add"
    @$cooperationImport = $(".js-cooperation-import")
    @cooperationEdit = ".js-cooperation-edit"
    @cooperationCheck = ".js-cooperation-check"
    @cooperationView = ".js-cooperation-view"
    @cooperationAccount = ".js-cooperation-account"
    @uploadFileBtn = ".js-file-upload"

    @bindEvent()
  that = this

  bindEvent: ->
    $(".cooperation").on "click", @cooperationNew, @newCooperation
    @$cooperationImport.on "click", @importCooperation
    $(".cooperation").on "click", @cooperationEdit, @editCooperation
    $(".cooperation").on "click", @cooperationCheck, @checkCooperation
    $(".cooperation").on "click", @cooperationView, @viewCooperation
    $(".cooperation").on "click", @cooperationAccount, @vendorUserAccount
    $(document).on "confirm:delete-cooperation",  @deleteCooperation
    $(document).on "click",@uploadFileBtn,@uploadFile
    that = this

  newCooperation: ->
    window.location.href = Store.context + "/mall/cooperation/cooperation_add";

#批量导入
  importCooperation: ->
    new Modal(vendorDownloadTemp(context:Store.context)).show()

  uploadFile:->
    $(that.uploadFileBtn).fileupload
      url:Store.context + "/api/admin/cooperation/importExcel"
      dataType: "json"
#      done: (e, result) =>
#        path = result.fileName
#        if result.success is true
#          path = result.fileName
#          $(".js-import-result").html(vendorImportResult({path:path,context:Store.context}))
#        else
#          $(".js-import-result").html("部分数据录入有误，导入分期费率失败")
      success:(data)->
        if data.success is true
          path = data.fileName
          $(".js-import-result").html(vendorImportResult({path:path,context:Store.context}))
        else
          $(".js-import-result").html("部分数据录入有误，导入分期费率失败")

      fail: (evt, data) ->
        jqXHR = data.jqXHR
        if jqXHR.status is 413
          "上传的文件超过规定大小"
        else
          jqXHR.responseText
      error:(data)->
        responseText = ""
        if data.status is 413 then responseText = "上传的文件超过规定大小" else responseText = data.responseText
        new Modal(
          icon: "error"
          title: "出错啦！"
          content: responseText
          overlay: false)
        .show()

  editCooperation: ->
    vendorId = $(@).closest("tr").data("id")
    window.location.href = Store.context + "/mall/cooperation/cooperation_edit?vendorId=" + vendorId;
  checkCooperation: ->
    vendorId = $(@).closest("tr").data("id")
    window.location.href = Store.context + "/mall/cooperation/cooperation_detail?flag=0&vendorId=" + vendorId;
  viewCooperation: ->
    vendorId = $(@).closest("tr").data("id")
    window.location.href = Store.context + "/mall/cooperation/cooperation_detail?vendorId=" + vendorId;
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
        window.location.href = Store.context + "/mall/cooperation/cooperation_all"

  vendorUserAccount:->
    vendorId = $(@).closest("tr").data("id")
    window.location.href = Store.context + "/mall/cooperation/vendorUser_account?vendorId="+ vendorId;

module.exports = MallCooperation
