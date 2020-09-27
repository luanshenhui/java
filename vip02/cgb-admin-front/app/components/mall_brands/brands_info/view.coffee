tipAndAlert = require "tip_and_alert/tip_and_alert"
Pagination = require "spirit/components/pagination"
Modal = require "spirit/components/modal"
Store = require "extras/store"

brandsAddTemp = App.templates["brands_new"]
brandsViewTemp = App.templates["brands_view"]
#brandsDownloadTemp = App.templates["brands_download"]
class BrandsInfo
  _.extend @::, tipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  second_click_tag = 0      #延迟tag
  constructor: ->
    @$addBrandBtn = $(".js-brand-add")
    @uploadImgBtn = ".js-image-upload"
    @$auditBrandBtn = $(".js-brand-audit")
    @$viewBrandBtn = $(".js-brand-view")
    @auditPassBtn = ".js-audit-pass"
    @auditRejectBtn = ".js-audit-reject"
    @$editBrandBtn = $(".js-brand-edit")
    @$delBrandBtn = $(".js-brand-del")
    @brandDetailBtn = $('.js-brand-detail')
    @largeImg = ".brandbigshow"
    @putStateBtn = $(".put-state")
    @bindEvent()
  that = this
  bindEvent: ->
    that = this
    @$addBrandBtn.on "click", @addBrand
    $(document).on "click", @uploadImgBtn, @uploadImg
    @$auditBrandBtn.on "click", @auditBrand
    @$viewBrandBtn.on "click", @viewBrand
    $(document).on "click", @auditPassBtn, @auditBrandConfirm
    $(document).on "click", @auditRejectBtn, @auditBrandConfirm
    @$editBrandBtn.on "click", @editBrand
#    @$importBrandBtn.on "click", @importBrand
    $(document).on "click", ".upload-brand-btn", @brandUpload
    $(document).on "confirm:delete-brand", @delBrand
    $(document).on "click", @largeImg, @largeimg
    $(document).on "keyup", '.js-approve-memeo', @remainingText
    $(document).on "blur", '.js-approve-memeo', @remainingText
    @brandDetailBtn.on 'click',@brandDetail
    $(document).on 'blur',".js-brands-name",@brandNameRepeated
    @putStateBtn.on "click",@putBrandState
    that.findBrandViewType()

  putBrandState:(evt)->
    id = $(@).closest("tr").data("id")
    state = $(@).closest("tr").data("data").brandState
    approveState = $(@).closest("tr").data("data").brandInforStatus
    if approveState isnt "01"
      that.alert "body", "error", "该品牌未通过审核，请稍后操作！"
      return
    changeState = "1"
    if state+"" is "1"
      changeState ="0"
    $.ajax
      url: Store.context + "/api/admin/brand/changeBrandState"
      type: "POST"
      data: id:id,state:changeState
      success:(data)->
        if data.data
          that.alert "body", "success", "保存成功！"
          window.location.reload()


#校验品牌名是否存在（实时校验）
  brandNameRepeated:->
    brandName = $(".js-brands-name").val()
    $(".brand-hava-new").hide()
    $(".brand-hava").hide()
    if brandName != ""
      $.ajax
        url: Store.context + "/api/admin/brand/add-checkBrandName"
        type: "GET"
        data:
          brandName: brandName
        success: (data)->
          if data.data?
            if data.data.brandInforStatus is "02"
              $(".brand-hava-new").show()
              return
            else
              $(".brand-hava").show()
              return

  brandDetail:->
    id = $(@).closest("tr").data("id")
    name = $(@).closest("tr").data("name")
    window.location.href = Store.context + "/mall/brands/brand-detail?brandId="+id+"&brandName="+name

  largeimg: (evl)->
    html = '<div class="pop-up" style="display: block;" onclick="$(\'.pop-up\').remove()">'
    html = html + '<img width="600px" height="400px"class="img-center" src='
    html = html + ($(".brandbigshow").attr('src'))
    html = html + '></div>'
    $("body").append(html)
  addBrand: (evt)->
    new Modal(brandsAddTemp({title: "新增品牌"})).show()
    that.findBrandType()
    $("form.brands-form").validator
      isErrorOnParent: true
    $("form.brands-form").on "submit", that.brandsFormSubmit


  brandsFormSubmit: (evt)->
    evt.preventDefault()
    brandName = $(".js-brands-name").val()
    $("form.brands-form").validator
      isErrorOnParent: true
    if brandName != ""
      $.ajax
        url: Store.context + "/api/admin/brand/add-checkBrandName"
        type: "GET"
        data:
          brandName: brandName
        success: (data)->
          if data.data?
            if data.data.brandInforStatus is "02"
              that.alert "body", "error", "品牌已存在被拒绝的请修改！"
              return
            else
              that.alert "body", "error", "品牌已存在！"
              return
          else
            data = $(".brands-form").serialize()
#            if $("input[name='brandImage']").val() is ""
#              that.alert "body", "error", "请上传品牌图标"
#              return
            if second_click_tag is 0 #防止连续点击
              second_click_tag = 1
              setTimeout (->
                second_click_tag = 0
              ), 1000
              $.ajax
                url: Store.context + "/api/admin/brand/add-brand"
                type: "POST"
                data: data
                success: (data)->
                  window.location.reload()


  uploadImg:->
    $(that.uploadImgBtn).fileupload
      url: Store.context + "/api/images/upload"
      dataType: "json"
      done: (e, result) =>
        $(".js-brand-img").attr("src",result.result[0].url)
        $("input[name='brandImage']").val(result.result[0].url)
        $(".js-brand-img").show()
        $(".brand-img-none").hide()
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


  viewBrand: (evt)->
    data = $(@).closest("tr").data("data")
    new Modal(brandsViewTemp({title: "查看品牌", data: data})).show()

  auditBrand: (evt)->
    data = $(@).closest("tr").data("data")
    type = "audit"
    if data.approveDiff?
      data = JSON.parse(data.approveDiff)
    new Modal(brandsViewTemp({title: "审核品牌", data: data, type: type})).show()

  auditBrandConfirm: (evt)->
    evt.preventDefault()
    approveStatus = "01"
    data = $(".brands-view-form").serializeObject()
    #如果是点击拒绝，将审核状态置为02，并移除图片
    if $(@).data("type") is "reject"
      approveStatus = "02"
      delete data.brandImage
      if $(".js-approve-memeo").val() is ""
        that.alert "body", "error", "请填写审核意见"
        return
    data.brandInforStatus = approveStatus
    if $(".js-approve-memeo").val() isnt ""
      data.approveMemo = $(".js-approve-memeo").val()
    data.approveDiff = ""
    $.ajax
      url: Store.context + "/api/admin/brand/audit"
      type: "POST"
      data: data
      success: (data)->
        if data.data == true
          window.location.reload()
        else
          that.alert "body", "error", "审核失败请刷新页面重试"

  editBrand: (evt)->
    data = $(@).closest("tr").data("data")
    new Modal(brandsAddTemp({title: "编辑品牌", data: data})).show()
    that.findBrandType()
    $("form.brands-form").validator
      isErrorOnParent: true
    $("form.brands-form").on "submit", that.brandsFormUpdate

  brandsFormUpdate: (evt)->
    evt.preventDefault()
    $("form.brands-form").validator
      isErrorOnParent: true
    data = $(".brands-form").serializeObject()
    approveDiff = $(".js-brand-data").data("data")
    approveDiff.brandImage = data.brandImage
    approveDiff.brandInforStatus = "00"
    data.approveDiff = JSON.stringify approveDiff
    data.brandInforStatus = "00"
    delete data.brandImage
    delete data.brandName
    $.ajax
      url: Store.context + "/api/admin/brand/edit"
      type: "POST"
      data: data
      success: (data)->
        window.location.reload()

  delBrand: (evt,data)->
    evt.preventDefault()
    id = data
    brandName = $(".del-name").val()
    $.ajax
      url: Store.context + "/api/admin/brand/delete-checkStatus"
      data:
        brandName: brandName
        brandId: id
      type: "POST"
      async: false
      success: (data)->
        if data.data is 0
          $.ajax
            url: Store.context + "/api/admin/brand/delete/#{id}"
            type: "POST"
            dataType: "JSON"
            success: (data)=>
              window.location.reload()
        else
          if data.data is 1
            that.alert "body", "error", "该品牌已被供应商授权，不允许删除"
            return false
          else if data.data is 2
            that.alert "body", "error", "该品牌已被产品使用，不允许删除"
            return false
          else
            that.alert "body", "error", "该品牌已被商品使用，不允许删除"
            return false
#  importBrand: (evt)->
#    evt.preventDefault()
#    new Modal(brandsDownloadTemp(context:Store.context)).show()

  brandUpload: (evt)->
    $(".upload-brand-btn").fileupload
      url: Store.context + "/api/admin/brand/import-excel"
      dataType: "json"
      success:(data)->
        if data.data.success is true
          resultFileName=data.data.fileName
          url =Store.context +  '/api/admin/backCategories/import-show?fileName='+ resultFileName
          $('.upload-result').html '<div><label for="downloadResult">上传文件：</label> '+ resultFileName + ' <a id="downloadResult" class="btn btn-small btn-info" href="' + url + '" >下载</a></div>'
        else
          that.alert "body", "error", "品牌导出失败"

# textarea ie兼容问题
  remainingText: ->
    val = $("#descript").val()
    length = parseInt(val.length)
    text = 100 - length
    if length >= 100
      $(@).val(val.substr(0, 100))
      text = 0
    $(".remaining-text i").text(text)


  findBrandType: ->
    $('.brand-type').append($('#brandCategoryId').html())
    $('.brand-type').val($('.brand-type-id').val())
#    $.ajax
#      url: Store.context + "/api/admin/brand/findBrandType"
#      type: "GET"
#      success: (data)->
#        typeList = data.data
#        if typeList
#          $('.brand-type').append('<option value="">请选择</option>')
#          for item, i in typeList
#            html = '<option value="' + item.categoryId + '">' + item.categoryName + '</option>'


  findBrandViewType: ->
    $.ajax
      url: Store.context + "/api/admin/brand/findBrandType"
      type: "GET"
      success: (data)->
        typeList = data.data
        if typeList
          $('#brandCategoryId').append('<option value="">请选择</option>')
          for item, i in typeList
            html = '<option value="' + item.categoryId + '">' + item.categoryName + '</option>'
            $('#brandCategoryId').append(html)
          $('#brandCategoryId').val($('.brandCategoryId').val())

module.exports = BrandsInfo