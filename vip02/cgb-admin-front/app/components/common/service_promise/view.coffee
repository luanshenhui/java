Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
tipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"
newRevicePromiseTemplate = App.templates["service_promise_add_edit"]
class defaultSearchTerm
  _.extend @::, tipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
    @promiseNew = ".js-promise-new"
    @promiseEdit = ".js-promise-edit"
    @largeImg = ".brandbigshow"
    @bindEvent()
    @uploadIconBtn = ".js-icon-upload"

  that = this

  bindEvent: ->
    that = this
    $(".service_promise").on "click", @promiseNew, @newPromise
    $(".service_promise").on "click", @promiseEdit, @editPromise
    $(document).on "confirm:delete-promise", @deleteConfirm
    $(document).on "click", @largeImg, @largeimg

  newPromise: =>
    $(".service-promise-form").find(".js-name-promise").attr("readonly",false)
    component =  new Modal(newRevicePromiseTemplate({title: "新增服务承诺",add:true})).show()
    $(".modal-promise-new").on "click", that.uploadIconBtn, that.uploadIcon
    $("form.service-promise-form").validator
       isErrorOnParent: true
    $("form.service-promise-form").on "submit", that.createServicePromise

  uploadIcon:(evt)->
    $(that.uploadIconBtn).fileupload
      url: Store.context +  "/api/images/upload"
      dataType: "json"
      done: (e, result) =>
        $(".js-promise-img").attr("src",result.result[0].url)
        $("input[name='icon']").val(result.result[0].url)
        $(".js-promise-img").show()
        $(".promise-img-none").hide()
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

  #新增
  createServicePromise: (evt)->
    evt.preventDefault()
    $("form.service-promise-form").validator
      isErrorOnParent: true
    $(".sort-required-error").remove()
    $(".termName-required-error").remove()
    #唯一性校验
    name = $(".js-name-promise").val()
    code = $(".js-name-promise").data("id")
    sort = $(".js-sort-promise").val()
    data =$(".service-promise-form").serialize()
    if name != ""
      data = {}
      data.name = name
      data.code = code
      data.sort = sort
      if data.sort isnt ""
        if !/^[1-9]\d*$/.test data.sort
          $("#sort").parent().append("<span class=\"sort-required-error required\"><i>&times;</i>请输入正整数</span>")
          return
      icon = $("#icon").val()
      if icon is ""
        that.alert "body","error","请上传服务承诺图标"
        return
      $.ajax
        url: Store.context + "/api/admin/servicePromise/checkServicePromise"
        type: "POST"
        data: data
        success: (data)->
          if data.data.nameCheck == false
            $("#name").parent().append("<span class=\"termName-required-error required\"><i>&times;</i> 服务承诺名称已存在</span>")
            return
          if data.data.sortCheck == false
            $("#sort").parent().append("<span class=\"termName-required-error required\"><i>&times;</i> 服务承诺顺序已存在</span>")
            return
          $.ajax
            url: Store.context + "/api/admin/servicePromise/add"
            type: "POST"
            data: $("form.service-promise-form").serialize()
            success: (data)->
              that.alert "body","success","保存成功！"
              window.location.reload()
  ##编辑
  editPromise: ->
    editServicePromise = $(@).closest("tr").data("data")
    new Modal(newRevicePromiseTemplate({title: "编辑服务承诺", data: editServicePromise})).show()
    # ADD START BY geshuo 20160728:测试缺陷 #19892,编辑图标无法上传
    $(".modal-promise-new").on "click", that.uploadIconBtn, that.uploadIcon
    # ADD END   BY geshuo 20160728:测试缺陷 #19892
    $("form.service-promise-form").validator()
    $("form.service-promise-form").on "submit", that.editConfirm

  editConfirm: (event)->
    event.preventDefault()
    $(".termName-required-error").remove()
    $("form.service-promise-form").validator
      isErrorOnParent: true
    data =$(".service-promise-form").serialize()
    $(".sort-required-error").remove()
    #唯一性校验
    name = $(".js-name-promise").val()
    code = $(".js-name-promise").data("id")
    sort = $(".js-sort-promise").val()
    if name != ""
      data = {}
      data.name = name
      data.code = code
      data.sort = sort
      if data.sort isnt ""
        if !/^[1-9]\d*$/.test data.sort
         $("#sort").parent().append("<span class=\"sort-required-error required\"><i>&times;</i>请输入正整数</span>")
         return
      icon = $("#icon").val()
      if icon is ""
        that.alert "body","error","请上传服务承诺图标"
        return
      $.ajax
        url: Store.context + "/api/admin/servicePromise/checkServicePromise"
        type: "POST"
        data: data
        success: (data)->
          if data.data.sortCheck == false
            $("#sort").parent().append("<span class=\"termName-required-error required\"><i>&times;</i> 服务承诺顺序已存在</span>")
            return
          code = $("#name").data("id")
          $.ajax
            url: Store.context + "/api/admin/servicePromise/edit/" + code
            type: "POST"
            data: $("form.service-promise-form").serialize()
            success: (data)->
              that.alert "body","success","更新成功！"
              window.location.reload()
  deleteConfirm: (evt, data)->
    $.ajax
      url: Store.context + "/api/admin/servicePromise/delete/" + data
      type: "POST"
      success: (data)->
        that.alert "body","success","删除成功！"
        window.location.reload()


  largeimg: (evl)->
    html = '<div class="pop-up" style="display: block;" onclick="$(\'.pop-up\').remove()">'
    html = html + '<img width="600px" height="400px"class="img-center" src='
    html = html + ($(".brandbigshow").attr('src'))
    html = html + '></div>'
    $("body").append(html)

module.exports = defaultSearchTerm
