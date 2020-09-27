Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"
cookie = require "extras/cookie"
tipAndAlert = require "tip_and_alert/tip_and_alert"

vendorItemTemplate = App.templates["for_vendor_item"] #供应商
vendorsModelTemplate = App.templates["for_model_vendor"] #供应商

htmlAddTemplate = App.templates["html_add"] #新增
htmlEditTemplate = App.templates["html_edit"] #上传

class HtmlUpload
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  _.extend @::, tipAndAlert, cookie

  startAdd = null
  endAdd = null
  startEdit = null
  endEdit = null

  constructor: ->
    @htmlLook = ".js-html-look"
    @htmlUpdate = ".js-html-update"
    @htmlPass = ".js-html-pass"
    @selectVendor = ".js-html-for"
    @searchBtn = ".js-search-btn"
    @vendorSave = ".js-save-vendor"
    @htmlNew = ".js-html-new"
    @uploadFileBtn = ".js-file-upload"
    @bindEvent()
  that = this

  bindEvent: ->
    that = this
    #预览
    $(document).on "click", @htmlLook, @lookHtml
    #通过
    $(document).on "confirm:pass-html", @auditHtml
    #拒绝
    $(document).on "confirm:refuse-html", @auditHtml
    #查询供应商
    $(document).on "click", @selectVendor, @vendorsQuery
    #搜索供应商按钮
    $(document).on "click", @searchBtn, @vendorsQuery
    #指定人
    $(document).on "click", @vendorSave, @saveVendor
    #新增
    $(document).on "click", @htmlNew, @htmlAdd
    #上传
    $(document).on "click", @htmlUpdate, @htmlEdit
    #发布
    $(document).on "confirm:push-html", @pushHtml
    #删除
    $(document).on "confirm:del-html", @delHtml

    if !that.getCookie("adminHtmlEnd")
      $.ajax
        url: Store.context + "/api/admin/html/findEndHtml"
        type: "POST"
        async: false
        success: (ret)->
          timeEnd = ''
          timeEnding = ''
          mes = ''
          if ret.data.timeEndList
            $.each ret.data.timeEndList, (i, d)->
              timeEnd += d + ' '
          if ret.data.timeEndingList
            $.each ret.data.timeEndingList, (i, d)->
              timeEnding += d + ' '
          if timeEnd isnt ''
            mes = "以下页面已经到期：" + timeEnd + "请及时处理！"
          if timeEnding isnt ''
            mes += "以下页面即将到期：" + timeEnding + "请及时处理！"
          if mes isnt ''
#存入cookie
            that.addCookie("adminHtmlEnd", "1", 1, $("body").data("base"))
            new Modal({
              icon: "error"
              title: "温馨提示"
              content: mes
              overlay: false
            }).show()
            left = ($("body").width() / 3)
            $(".modal-dialog").css({"width": "300px", "left": left})
        error: (ret)->
          that.alert "body", "error", "出错啦！", ret.responseText
          $(".alert").css("z-index", 999)

## 上传zip包
  uploadImportFile: (channelUrl)->
    $(that.uploadFileBtn).fileupload
      url: Store.context + channelUrl
      dataType: "text"
      done: (e, data) =>
        fileName = data.originalFiles[0].name
        data = data.result
        if data is "success"
          $(".actId").val(fileName.substring(0, fileName.indexOf(".zip")))
          $("#fileZipAdd").data("uploadFlag", "success")
          $(".zip-upload").find(".tip-upload").remove()
          $(".uploadArea").after("<span class=\"tip-upload\" style=\"font-weight: bold;color: #f01919 !important;\">文件上传成功!</span>")
          $(".js-submit-btn").removeAttr("disabled")
        else
          $("#fileZipAdd").data("uploadFlag", "fail")
          $(".zip-upload").find(".tip-upload").remove()
          $(".uploadArea").after("<span class=\"tip-upload\" style=\"font-weight: bold;color: #f01919 !important;\">文件上传失败，请重新上传!</span>")
          $(".actId").val("")
          if data
            errorMsg = data.substring data.indexOf("-") + 1, data.length ##截取错误信息
            switch errorMsg
              when "empty"
                that.alert "body", "error", "上传文件不能为空"
                $(".alert").css("z-index", 999)
              when "notZip"
                that.alert "body", "error", "请选择.zip文件"
                $(".alert").css("z-index", 999)
              when "findError"
                that.alert "body", "error", "查询失败"
                $(".alert").css("z-index", 999)
              when "findExist"
                that.alert "body", "error", "文件名重复"
                $(".alert").css("z-index", 999)
              when "localExist"
                that.alert "body", "error", "本地已存在"
                $(".alert").css("z-index", 999)
              when "gbkInZip"
                that.alert "body", "error", "压缩包中包含中文字符"
                $(".alert").css("z-index", 999)
              when "gbkInName"
                that.alert "body", "error", "压缩包包含中文字符或特殊字符"
                $(".alert").css("z-index", 999)
              when "uploadFile"
                that.alert "body", "error", "上传失败"
                $(".alert").css("z-index", 999)
              when "tooLongName"
                that.alert "body", "error", "文件名称不能大于8位字符"
                $(".alert").css("z-index", 999)
              when "equalError"
                that.alert "body", "error", "上传文件名，请与“静态页面代码”保持一致"
                $(".alert").css("z-index", 999)
#              else
#                that.alert "body", "error", "未知错误"
#                $(".alert").css("z-index", 999)
          else
            that.alert "body", "error","无返回结果"
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


#新增弹窗
  htmlAdd: ()->
    ordertypeId = $(".js-html-title").data("id")
    new Modal(htmlAddTemplate({ordertypeId: ordertypeId})).show()
    ## 监听绑定 注意 不可传参！！！！！ 需写一个匿名方法 进行 执行
    $(".html-add").on "click", that.uploadFileBtn, ->
      that.uploadImportFile("/api/admin/html/add-zip")

    startAdd = {
      elem: '#js-date-startAdd',
      format: 'YYYY-MM-DD hh:mm:ss', #自动生成的时间格式
      istime: true, #必须填入时间
      choose: (data)->
        endAdd.min = data #开始日选好后，重置结束日的最小日期
        endAdd.start = data #将结束日的初始值设定为开始日
    }
    endAdd = {
      elem: '#js-date-endAdd',
      format: 'YYYY-MM-DD hh:mm:ss', #自动生成的时间格式
      istime: true, #必须填入时间
      choose: (data)->
        startAdd.max = data  #将结束日的初始值设定为开始日
    }

    setTimeout (->
      laydate(startAdd)
      laydate(endAdd)
    ), 1000

    $("form.html-add-form").validator
      isErrorOnParent: true

    $("form.html-add-form").on "submit", that.htmlAddSubmit

#新增提交
  htmlAddSubmit: (evt)->
    evt.preventDefault()
    $("form.html-add-form").validator
      isErrorOnParent: true
    formData = $("form.html-add-form").serializeObject()
    #校验文件名称
    uploadFlag = $("#fileZipAdd").val()
    #开始时间大于结束时间
    startTime = $(".startTime").val()
    endTime = $(".endTime").val()
    if startTime is ''
      that.alert "body", "error", "时间不可为空"
      $(".alert").css("z-index", 999)
      return
    if endTime is ''
      that.alert "body", "error", "时间不可为空"
      $(".alert").css("z-index", 999)
      return
    if startTime >= endTime
      that.alert "body", "error", "开始时间不能大于结束时间"
      $(".alert").css("z-index", 999)
      return
    if uploadFlag is "success"
      that.alert "body", "error", "文件上传异常，请重新上传文件"
      $(".alert").css("z-index", 999)
      return
    $.ajax
      url: Store.context + "/api/admin/html/add"
      type: "POST"
      data: formData
      success: (data)->
        if data.data
          window.location.reload()
      error: (ret)->
        $(".actId").val("")
        that.alert "body", "error", ret.responseText
        $(".alert").css("z-index", 999)

#上传弹窗
  htmlEdit: ()->
    result = $(@).closest("tr").data("data")
    actId = $(@).closest("tr").find(".html-act-id").text()
    new Modal(htmlEditTemplate({data: result, actId: actId})).show()
    $(".html-edit").on "click", that.uploadFileBtn, ->
      that.uploadImportFile("/api/admin/html/edit-zip")

    startEdit = {
      elem: '#js-date-startEdit',
      format: 'YYYY-MM-DD hh:mm:ss', #自动生成的时间格式
      istime: true, #必须填入时间
      choose: (data)->
        endEdit.min = data #开始日选好后，重置结束日的最小日期
        endEdit.start = data #将结束日的初始值设定为开始日
    }
    endEdit = {
      elem: '#js-date-endEdit',
      format: 'YYYY-MM-DD hh:mm:ss', #自动生成的时间格式
      istime: true, #必须填入时间
      choose: (data)->
        startEdit.max = data  #将结束日的初始值设定为开始日
    }

    setTimeout (->
      laydate(startEdit)
      laydate(endEdit)
    ), 1000

    $("form.html-edit-form").validator
      isErrorOnParent: true
    $("form.html-edit-form").on "submit", that.htmlEditSubmit

#编辑提交
  htmlEditSubmit: (evt)->
    evt.preventDefault()
    $("form.html-edit-form").validator
      isErrorOnParent: true
    formData = $("form.html-edit-form").serializeObject()
    #开始时间大于结束时间
    startTime = $(".startTime").val()
    endTime = $(".endTime").val()
    #校验文件名称
    uploadFlag = $("#fileZipAdd").val()
    if startTime is ''
      that.alert "body", "error", "时间不可为空"
      $(".alert").css("z-index", 999)
      return
    if endTime is ''
      that.alert "body", "error", "时间不可为空"
      $(".alert").css("z-index", 999)
      return
    if startTime >= endTime
      that.alert "body", "error", "开始时间不能大于结束时间"
      $(".alert").css("z-index", 999)
      return
    if uploadFlag is "success"
      that.alert "body", "error", "文件上传异常，请重新上传文件"
      $(".alert").css("z-index", 999)
      return
    $.ajax
      url: Store.context + "/api/admin/html/update"
      type: "POST"
      data: formData
      success: (data)->
        if data.data
          window.location.reload()
      error: (ret)->
        $(".actId").val("")
        that.alert "body", "error", ret.responseText
        $(".alert").css("z-index", 999)

#预览
  lookHtml: ->
    url = $(@).data("url")
    #    window.location.href = url
    window.open(url);

#通过
  auditHtml: (evt, data)->
    type = evt.type
    index = type.indexOf("pass")
    if index isnt -1
      operate = "pass"
    else
      operate = "refuse"
    actId = data
    $.ajax
      url: Store.context + "/api/admin/html/audit-html"
      type: "GET"
      data: {
        actId: actId
        operate: operate
      }
      success: (data)->
        window.location.reload()
      error: (ret)->
        that.alert "body", "error", ret.responseText
        $(".alert").css("z-index", 999)

#拒绝
#  refuseHtml: (evt, data)->
#    actId = data
#    $.ajax
#      url: Store.context + "/api/admin/html/audit-refuse"
#      type: "POST"
#      data: {
#        actId: actId
#      }
#      success: (data)->
#        window.location.reload()
#      error: (ret)->
#        that.alert "body", "error", ret.responseText
#        $(".alert").css("z-index", 999)

#发布
  pushHtml: (evt, data)->
    uri = Store.context + "/api/admin/html/publish/#{data}"
    uri = encodeURI(uri)
    $.ajax
      url: uri
      type: "GET"
      success: (data)->
        if data.data
          window.location.reload()
      error: (ret)->
        that.alert "body", "error", ret.responseText
        $(".alert").css("z-index", 999)
  ## 删除
  delHtml: (evt, data)->
    publishStatus = $("#"+data).parents("tr").data("data").publishStatus
    uri = Store.context + "/api/admin/html/delHtml/#{data}?status=#{publishStatus}"
    uri = encodeURI(uri)
    $.get uri, (data) =>
      if data.data
        window.location.reload()
      else
        that.alert "body", "error", "删除失败"
        $(".alert").css("z-index", 999)


#供应商查询
  vendorsQuery: (evt)->
    evt.preventDefault()

    $tr = $(@).closest("tr").find(".html-act-id")
    if $tr
      modelFlag = true ## 判断 model打开标识
      actId = $tr.text()
    else
      modelFlag = false

    ordertypeId = $(".js-html-title").data("id") ## 业务ID
    searchKey = $(".vendor-search-value").val() ## 关键字搜索
    if !searchKey
      searchKey = ""

    $.ajax
      url: Store.context + "/api/admin/cooperation/findVendorsByNameLike"
      type: "GET"
      data: {
        keyword: searchKey
        channel: ordertypeId
      }
      success: (data)->
        if modelFlag
          new Modal(vendorsModelTemplate({
            ordertypeId: ordertypeId,
            list: data.data.result,
            actId: actId
          })).show()
        else
          $(".setting-scrll").html(vendorItemTemplate({
            list: data.data.result
          }))

      error: (ret)->
        that.alert "body", "error", ret.responseText
        $(".alert").css("z-index", 999)

## 保存 指派人
  saveVendor: ->
    vendorId = $('[name="updateOper"]:checked').val()
    if vendorId is ""
      vendorId = null
    actId = $(@).data("id")
    $.ajax
      url: Store.context + "/api/admin/html/assign"
      type: "GET"
      data: {
        actId: actId
        vendorId: vendorId
      }
      success: (data)->
        if data.data
          window.location.reload()
      error: (ret)->
        that.alert "body", "error", ret.responseText
        $(".alert").css("z-index", 999)


module.exports = HtmlUpload
