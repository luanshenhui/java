Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
tipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"
image = require("extras/image")

class espAdvertise
  _.extend @::, tipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
    @addEspadvertise = ".js-advertise-new"
    @editEspadvertise = ".js-advertise-edit"
    @selectOrdertypeId = ".js-select-ordertypeId"
    @selectJumping = ".select_jumping"
    @updateIsStop = ".js-isStop-update"
    @select1 = ".js-select1" #后台类目一级
    @select2 = ".js-select2" #后台类目二级
    @select3 = ".js-select3" #后台类目三级
    @largeImg = ".js-image-show"
    @bindEvent()
    @uploadIconBtn = ".js-icon-upload"

  newEspadvertiseTemplate = App.templates["esp_advertise_add_edit"]
  that = this

  bindEvent: ->
    that = this
    $(".esp_advertise").on "click", @addEspadvertise, @espAdvertiseAdd
    $(".esp_advertise").on "click", @editEspadvertise, @espAdvertiseEdit
    $(".esp_advertise").on "click", @updateIsStop, @isStopUpdate # 启用状态更新
    $(document).on "change", @selectOrdertypeId, @orderTypeIdSelect #业务类型选择
    $(document).on "change", @selectJumping, @jumpingSelect #跳转类型选择
    $(document).on "confirm:delete-advertise", @deleteConfirm #删除
    $(document).on "confirm:update-advertise", @updateConfirm #发布
    $(document).on "change", @select1, @selectCategory
    $(document).on "change", @select2, @selectCategory
    $(".esp_advertise").on "click", @largeImg, @imgShow #预览（图片）

  jumpingSelect: ->
    if $(that.selectJumping).val() is ''
      if $(".js-select-ordertypeId").val() is 'YG'
        $("#keywordinp").show()
        $("#advertiseHref").show()
        $("#advertiseHref-name").html("链接地址")
        $("#advertiseHref-text").hide()
        $("#partitions").hide()
        $("#classifications").hide()
      if $(".js-select-ordertypeId").val() is 'JF'
        $("#keywordinp").hide()
        $("#advertiseHref").show()
        $("#advertiseHref-name").html("单品编码")
        $("#advertiseHref-text").show()
        $("#partitions").show()
        $("#classifications").show()
    if $(that.selectJumping).val() is '1'
      $("#keywordinp").show()
      $("#advertiseHref").hide()
      $("#partitions").hide()
      $("#classifications").hide()
    if $(that.selectJumping).val() is '2'
      $("#keywordinp").hide()
      $("#advertiseHref").show()
      $("#advertiseHref-name").html("链接地址")
      $("#advertiseHref-text").hide()
      $("#partitions").hide()
      $("#classifications").hide()
    if $(that.selectJumping).val() is '3'
      $("#keywordinp").hide()
      $("#advertiseHref").hide()
      $("#partitions").show()
      $("#classifications").hide()
    if $(that.selectJumping).val() is '4'
      $("#keywordinp").hide()
      $("#advertiseHref").hide()
      $("#partitions").hide()
      $("#classifications").show()
    if $(that.selectJumping).val() is '5'
      $("#keywordinp").hide()
      $("#advertiseHref").show()
      $("#advertiseHref-name").html("单品编码")
      $("#advertiseHref-text").show()
      $("#partitions").hide()
      $("#classifications").hide()

  orderTypeIdSelect: ->
    if $(@).val() is ''
      $(".select_jumping").html("")
      $(".select_jumping").html("<option value=''>请选择</option><option  value='1'>关键字</option><option  value='2'>页面</option><option  value='3'>分区</option><option  value='4'>类别</option><option  value='5'>商品</option>")
      $("#keywordinp").show()
      $("#advertiseHref").show()
      $("#partitions").show()
      $("#classifications").show()
    if $(@).val() is 'YG'
      $(".select_jumping").html("")
      $(".select_jumping").html("<option value=''>请选择</option><option  value='1'>关键字</option><option  value='2'>页面</option>")
      $("#keywordinp").show()
      $("#advertiseHref").show()
      $("#advertiseHref-name").html("链接地址")
      $("#advertiseHref-text").hide()
      $("#partitions").hide()
      $("#classifications").hide()
    if $(@).val() is 'JF'
      $(".select_jumping").html("")
      $(".select_jumping").html("<option value=''>请选择</option><option  value='3'>分区</option><option  value='4'>类别</option><option  value='5'>商品</option>")
      $("#keywordinp").hide()
      $("#advertiseHref").show()
      $("#advertiseHref-name").html("单品编码")
      $("#advertiseHref-text").show()
      $("#partitions").show()
      $("#classifications").show()


#添加
  espAdvertiseAdd: =>
    @backCategoryInit()
    #查询类目
    component = new Modal newEspadvertiseTemplate({title: "新增手机广告",add:true})
    component.show()
    $(".modal-advertise-new").on "click", that.uploadIconBtn, that.uploadIcon
    $(that.componentForm).validator
      isErrorOnParent: true
    $("form.esp-advertise-form").on "submit", that.createEspadvertise
#编辑
  espAdvertiseEdit: ->
    editServiceAdvertise = $(@).closest("tr").data("data")
    that.backCategoryInit(editServiceAdvertise)
    new Modal(newEspadvertiseTemplate({title: "编辑手机广告", data: editServiceAdvertise})).show()
    $(".modal-advertise-new").on "click", that.uploadIconBtn, that.uploadIcon
    that.jumpingSelect()
    $(that.componentForm).validator
      isErrorOnParent: true
    $("form.esp-advertise-form").validator()
    $("form.esp-advertise-form").on "submit", that.editConfirm

  editConfirm: (evt) ->
    #event.preventDefault()
    $("form.esp-advertise-form").validator
    evt.preventDefault()
    data = $(".esp-advertise-form").serializeObject()
    data.ordertypeId = $("#ordertypeIdEdit").val()
    data.advertisePos = $("#advertisePosEdit").val()
    data.linkType = $("#linkType").val()
    id = $("#advertiseId").data("id")
    $(".esp-advertise-form").validator
      isErrorOnParent: true
    if data.ordertypeId is ''
      that.alert "body", "error", "请选择业务类型！"
      return
    if data.advertisePos is ''
      that.alert "body", "error", "请选择广告类型！"
      return
    if data.linkType is ''
      that.alert "body", "error", "请选择跳转类型！"
      return
    if data.linkType is '1'
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.keyword #关键字名称
        that.tip $("#keyword").parent(), "error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36).css("width", 150)
        return
    if data.linkType is '2'
      if data.advertiseHref is ''
        that.alert "body", "error", "请填写页面链接！"
        return
    if data.linkType is '3'
      if data.partitionsKeyword is ''
        that.alert "body", "error", "请选择分区！"
        return
    if data.linkType is '4'
      if data.backCategory1Id is ''
        that.alert "body", "error", "请选择一级类别！"
        return
      if data.backCategory2Id is ''
        that.alert "body", "error", "请选择二级类别！"
        return
      if data.backCategory3Id is ''
        that.alert "body", "error", "请选择三级类别！"
        return
    if data.linkType is '5'
      if data.advertiseHref is ''
        that.alert "body", "error", "请填写单品编码！"
        return
    if data.advertiseSeq is ''
      that.alert "body", "error", "请填写显示顺序！"
      return
    if !/^[1-9]\d*$/.test data.advertiseSeq
      that.alert "body", "error", "显示顺序只能是正整数！"
      return
#    $.ajax
#      url: Store.context + "/api/admin/espAdvertise/checkAdvertiseSeq"
#      type: "POST"
#      data: data
#      success: (data)->
#        if data.data == false
#          new Modal(
#            icon: "error"
#            title: "温馨提示"
#            content: "显示顺序已存在，请重新输入！"
#            overlay: false)
#          .show()
#          return
        # ADD START BY geshuo 20160725:[测试缺陷 #19668]添加下拉框的参数
#        editParams = $("form.esp-advertise-form").serialize()
#        editParams += "&linkType=" + $("#linkType").val()
#        editParams += "&ordertypeId=" + $("#ordertypeIdEdit").val()
#        editParams += "&advertisePos=" + $("#advertisePosEdit").val()
        # ADD END   BY geshuo 20160725:[测试缺陷 #19668]
    $.ajax
      url: Store.context + "/api/admin/espAdvertise/edit/" + id
      type: "POST"
      dataType: "JSON"
      data: $("form.esp-advertise-form").serialize()
      success: (data)->
        that.alert "body", "success", "更新成功！"
        window.location.reload()

  createEspadvertise: (evt)->
    ###新增逻辑###
    $("form.default-term-form").validator()
    evt.preventDefault()
    data = $("form.esp-advertise-form").serializeObject();
    $(".esp-advertise-form").validator
      isErrorOnParent: true
    if data.ordertypeId is ''
      that.alert "body", "error", "请选择业务类型！"
      return
    if data.advertisePos is ''
      that.alert "body", "error", "请选择广告类型！"
      return
    if data.linkType is ''
      that.alert "body", "error", "请选择跳转类型！"
      return
    if data.linkType is '1'
      if !/^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/.test data.keyword #关键字名称
        that.tip $("#keyword").parent(), "error", "up", "不能输入特殊字符！"
        $(".tip").css("left", 180).css("top", 36).css("width", 150)
        return
    if data.linkType is '2'
      if data.advertiseHref is ''
        that.alert "body", "error", "请填写页面链接！"
        return
    if data.linkType is '3'
      if data.partitionsKeyword is ''
        that.alert "body", "error", "请选择分区！"
        return
    if data.linkType is '4'
      if data.backCategory1Id is ''
        that.alert "body", "error", "请选择一级类别！"
        return
      if data.backCategory2Id is ''
        that.alert "body", "error", "请选择二级类别！"
        return
      if data.backCategory3Id is ''
        that.alert "body", "error", "请选择三级类别！"
        return
    if data.linkType is '5'
      if data.advertiseHref is ''
        that.alert "body", "error", "请填写单品编码！"
        return
    if data.advertiseSeq is ''
      that.alert "body", "error", "请填写显示顺序！"
      return
    if !/^[1-9]\d*$/.test data.advertiseSeq
      that.alert "body", "error", "显示顺序只能是正整数！"
      return

#    $.ajax
#      url: Store.context + "/api/admin/espAdvertise/checkAdvertiseSeq"
#      type: "POST"
#      data: data
#      success: (data)->
#        if data.data == false
#          new Modal(
#            icon: "error"
#            title: "温馨提示"
#            content: "显示顺序已存在，请重新输入！"
#            overlay: false)
#          .show()
#          return
    $.ajax
      url: Store.context + "/api/admin/espAdvertise/add"
      type: "POST"
      dataType: "JSON"
      data: $("form.esp-advertise-form").serialize()
      success: (data)->
        that.alert "body", "success", "保存成功！"
        window.location.reload()

  #删除
  deleteConfirm: (evt, data)->
    $.ajax
      url: Store.context + "/api/admin/espAdvertise/delete"
      type: "POST"
      data: {"id": data}
      success: (data)->
        that.alert "body", "success", "删除成功！"
        window.location.reload()
  #发布
  updateConfirm: (evt, data) ->
    publishStatus = $(".publishStatus-name").val()
    if publishStatus is '00'
      that.alert "body", "error", "已经发布，不能再次发布！"
      return
    $.ajax
      url: Store.context + "/api/admin/espAdvertise/announcement"
      type: "POST"
      data: {"id": data}
      success: (data)->
        that.alert "body", "success", "发布成功！"
        window.location.reload()
  #更新启用状态
  isStopUpdate: ->
    publishStatus = $(@).data("value")
    id = $(@).data("id")
    isStop = $(@).data("type")
    if publishStatus isnt "00"
      that.alert "body", "error", "该条广告暂未发布，请发布后修改启用状态！"
      return
    $.ajax
      url: Store.context + "/api/admin/espAdvertise/updateIsStop"
      type: "POST"
      data:
        id: id, isStop: isStop
      success: (data)->
        that.alert "body", "success", "更新成功！"
        window.location.reload()

  uploadIcon:(evt)->
    evt.preventDefault()
    image.selector().done (image_url) ->
      $("#advertiseImage").val(image_url)


  ###后台类目联动###
  selectCategory: ()->
    id = $(@).val()
    level = $(@).data("level")
    nextLevel = level + 1
    #如果点击的是请选择，则return
    if id is ""
      $("select[data-level=" + nextLevel + "]").html('<option  value="">请选择</option>')
      if level is 1
        $("select[data-level=3]").html('<option  value="">请选择</option>')
      return
    $.ajax
      url:Store.context + "/api/admin/goods/look-toAddGdCat"
      type: "POST"
      data:
        id: id
      success: (result)->
        if level is 1
          $("select[data-level=3]").html('<option  value="">请选择</option>')
        html = ''
        $.each(result.data, (index, item)->
          html += '<option  value=' + item.id + '>' + item.name + '</option>'
        )
        $("select[data-level=" + nextLevel + "]").html('<option  value="">请选择</option>').append(html)
#图片预览
  imgShow: ()->
    imageStatus = $(@).closest("tr").data("value")
    if imageStatus is ""
      that.alert "body", "error", "图片未上传！"
      return
    html = '<div class="pop-up" style="display: block;" onclick="$(\'.pop-up\').remove()">'
    html = html + '<img width="600px" height="400px"class="img-center" src='
    html = html + ($(@).data('img'))
    html = html + '></div>'
    $("body").append(html)

  #后台类目初始化
  backCategoryInit: (editServiceAdvertise)->
    if editServiceAdvertise isnt '' and editServiceAdvertise isnt undefined
      if editServiceAdvertise.linkType is '4'
        backCategoryId = editServiceAdvertise.keyword.split(">")
        backCategory1 = backCategoryId[0]
        backCategory2 = backCategoryId[1]
        backCategory3 = backCategoryId[2]
    id = 0
    #获取类别id
    $.ajax
      url:Store.context + "/api/admin/goods/look-toAddGdCat"
      type: "POST"
      data:
        id: id
      success: (result)->
        html = ''
        $.each(result.data, (index, item)->
          html += '<option  value=' + item.id + '>' + item.name + '</option>'
        )
        $('.js-select1').html('<option  value="">请选择</option>').append(html)
        $('.js-select1').val(backCategory1)
        if backCategory1 isnt true and backCategory1 isnt "" and backCategory1 isnt undefined
          $.ajax
            url: Store.context + "/api/admin/goods/look-toAddGdCat"
            type: "POST"
            data:
              id: backCategory1
            success: (result)->
              html = ''
              $.each(result.data, (index, item)->
                html += '<option  value=' + item.id + '>' + item.name + '</option>'
              )
              $("select[data-level=2]").html('<option  value="">请选择</option>').append(html)
              $('.js-select2').val(backCategory2)
              if backCategory2 isnt true and backCategory2 isnt "" and backCategory2 isnt undefined
                $.ajax
                  url:Store.context +  "/api/admin/goods/look-toAddGdCat"
                  type: "POST"
                  data:
                    id: backCategory2
                  success: (result)->
                    html = ''
                    $.each(result.data, (index, item)->
                      html += '<option  value=' + item.id + '>' + item.name + '</option>'
                    )
                    $("select[data-level=3]").html('<option  value="">请选择</option>').append(html)
                    $('.js-select3').val(backCategory3)

module.exports = espAdvertise
