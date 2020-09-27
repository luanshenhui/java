Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"
#编辑弹出框模板
editWechatItemTemplate = App.templates["editWechatItem"]
uploadWechatItemTemplate = App.templates["uploadWechatItem"]
class wechatItemManage
  #分页
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  _.extend @::, TipAndAlert
  constructor: ->
#点击编辑按钮
    @editWechatItem = ".js-wechat-edit"
    #编辑保存
    @saveEditWechat = ".js-wechat-save"
    #微信批量导入
    @uploadWechatItem = ".js-wechat-upload"
    #选择文件
    @uploadFileBtn = ".js-file-upload"
    #微信商品排序删除
    #    @deleteWeChat = ".js-wechat-delete"
    #    @uploadBtn = ".js-upload-btn"
    @bindEvent()
  that = this
  bindEvent: ->
    that = this
    $(".wechatItemManage").on "click", @editWechatItem, @ItemEditWechat
    $(".wechatItemManage").on "click", @uploadWechatItem, @wechatItemUpload
   # $(document).on "confirm:delete-wechat", @deleteWechatOrder
    $(document).on "change", "#wxOrder", @checkWxOrder
    $(document).on "keyup", "#wxOrder", @checkWxOrder

#校验微信礼品排序字段
  checkWxOrder: ->
    order = $("#wxOrder").val()
    if !/^$|^[1-9][0-9]*$/.test order
      $(".wxOrder-note-error").show()
    else
      $(".wxOrder-note-error").hide()
#编辑弹出框
  ItemEditWechat: ->
    data = $(@).closest("tr").data("data")
    new Modal(editWechatItemTemplate({data: data})).show()
    $("form.js-wx-form").validator
      isErrorOnParent: true
    $("form.js-wx-form").on "submit", that.editWechatSave

#编辑顺序保存功能
  editWechatSave: (evt)->
    evt.preventDefault()
    $("form.js-wx-form").validator
      isErrorOnParent: true
    order = $("#wxOrder").val()
    if !/^$|^[1-9][0-9]*$/.test order
      $(".wxOrder-note-error").show()
      return
    itemCode = $("#itemcode").val()
    $.ajax
      url: Store.context + "/api/admin/GoodsWeChat/editItemWeChat"
      type: "POST"
      data:
        wxOrder: order, code: itemCode
      success: (data)->
        window.location.reload()
      error: (data) ->
        new Modal(
          icon: "error"
          title: "出错啦！"
          content: data.responseText || "未知故障"
          overlay: false)
        .show()

#微信商品排序删除
#  deleteWechatOrder: (evt, data)->
#    evt.preventDefault()
#    #    itemCode = $(@).parent().parent().data("id")
#    $.ajax
#      url: Store.context + "/api/admin/GoodsWeChat/deleteItemWeChat"
#      type: "POST"
#      data:
#        code: data
#      success: (data)->
#        that.alert "body", "success", "删除成功"
#        window.location.reload()

#导入弹出框
  wechatItemUpload: ->
    new Modal(uploadWechatItemTemplate(context: Store.context)).show()
    $(".wechat-import-modal").on "click", that.uploadFileBtn, that.uploadFile ##上传文件
#    $(".wechat-import-modal").on "click", that.uploadBtn, that.uploadBtnListener

#  btnUploadFile: ->
#    $("#files").trigger("click")

#  fileChoose: (evt) ->
#    fileName = $('#files').val()
#    #文件名
#    fileName = fileName.split('\\')
#    fileName = fileName[fileName.length - 1]
#    $(".js-import-file-name").attr("value", fileName);
#    $('.js-file-choose-btn').hide()
#    $('.js-file-upload-btn').show()

## 点击按钮调uploadFileBtn控件
#  uploadBtnListener: ->
#    $(that.uploadFileBtn).trigger("click")
##上传文件
  uploadFile: ->
    $(that.uploadFileBtn).fileupload
      url: Store.context + "/api/admin/GoodsWeChat/uploadItemWeChat"
      dataType: "json"
      done: (e, data) =>
        fileName = data.originalFiles[0].name
        dataSet = data.result
        if dataSet.isSuccess
          resultFileName = dataSet.fileName
          url = Store.context + '/api/admin/GoodsWeChat/exportFile?fileName=' + resultFileName
          if dataSet.isImportSuccess
            $('.download-result').html '<div><p><strong class="divStyle">导入成功！</strong></p><label for="downloadResult">如需下载，请点击：</label> ' + fileName + ' <a id="downloadResult" class="btn btn-small btn-info" href="' + url + '" >下载</a></div>'
          else
            $('.download-result').html '<div><p><strong class="divStyle">部分数据导入失败！</strong></p><label for="downloadResult">如需下载，请点击：</label> ' + fileName + ' <a id="downloadResult" class="btn btn-small btn-info" href="' + url + '" >下载</a></div>'
        else
          errorCode = dataSet.errorCode
          switch errorCode
            when "fileNotExist"
              that.alert "body", "error", "上传文件不存在！"
            when "fileIllegalExt"
              that.alert "body", "error", "请选择.xls或.xlsx文件上传！"
            when "deleteExistFile"
              that.alert "body", "error", "无法删除同名文件！"
            when "emptyFile"
              that.alert "body", "error", "导入信息不能为空！"
            when "updateData"
              that.alert "body", "error", "更新数据失败！"
            else
              errorMsg = dataSet.errorMsg
              that.alert "body", "error", "未知错误！", errorMsg
      fail: (evt, data) ->
        jqXHR = data.jqXHR
        if jqXHR.status is 413
          "上传的文件超过规定大小"
        else
          jqXHR.responseText
      error: (data)->
        responseText = ""
        if data.status is 413 then responseText = "上传的文件超过规定大小" else responseText = data.responseText
        new Modal(
          icon: "error"
          title: "出错啦！"
          content: responseText
          overlay: false)
        .show()

module.exports = wechatItemManage