Modal = require "spirit/components/modal"
Store = require "extras/store"
TipAndAlert = require "tip_and_alert/tip_and_alert"
image = require "extras/image"

class itemReviewDetail
  addSpecialsItemsTemplate = App.templates["add_specials_items"]
  that = this
  brandId = ''
  addSpecialsItemsModal = null

  constructor: ->
    @addItemsButton = $('.add-items')
    @itemDeletedButton = '.item-deleted'
    @$uploadIconBtn = $(".js-icon-upload")
    #绑定事件
    @bindEvent()
    brandId = $.query.get("brandId")
    brandName = $.query.get("brandName")
    $('.barnd-name').val(brandName)
    $('.brand-id').val(brandId)

    @selectSpecialsItems()
#    @findBrandType()

    $(".brand-type").change ->
      checkText = $(".brand-type").find("option:selected").text()
      $('.brand-type-name').val(checkText)

#绑定事件
  bindEvent: ->
    that = this
    @addItemsButton.on "click", @addItems
    $(document).on "click", @itemDeletedButton, @itemDeleted
    $("form.brand-detail-form").validator isErrorOnParent: true
    $("form.brand-detail-form").on "submit", @passed
    @$uploadIconBtn.on "click",@uploadIcon
    $(document).on "blur" ,".carousel-ad",@checkhaveAd

  checkhaveAd:->
    errorBody = $(@).parent().find(".slide-error-none")
    $(@).parent().find(".note-error").hide()
    errorBody.hide()
    slId = $.trim($(@).val())
    if slId == ""
      return
    slideid = Number(slId)
    if isNaN(slideid)
      $(@).parent().find(".note-error").show()
      return
    $.ajax
      url: Store.context + "/api/admin/brand/checkCarouselId"
      type: "GET"
      data: slide : slideid
      success: (data)->
        if data.data != "true" && data.data != true
          errorBody.html("<i>&times;</i>"+data.data)
          errorBody.show()
    
  uploadIcon:(evt)->
    evt.preventDefault()
    image.selector().done (image_url) ->
      $(".js-brand-img").attr "src", image_url
      $("#brandImage").val(image_url)
      $(".brand-img-none").hide()
      $(".js-brand-img").show()

  addItems: (event)->
    event.preventDefault()
    addSpecialsItemsModal = new Modal addSpecialsItemsTemplate({title: "限时特价商品新增", id: brandId})
    addSpecialsItemsModal.show()
    $("form.add-specials-form").validator
      isErrorOnParent: true
    $("form.add-specials-form").on "submit", that.addSpecialsItems

  addSpecialsItems: (event) ->
    event.preventDefault()
    $("form.add-specials-form").validator
      isErrorOnParent: true
    $.ajax
      url: Store.context + "/api/admin/goodscommend/add"
      type: "POST"
      data: $("form.add-specials-form").serialize()
      success: (data)->
        addSpecialsItemsModal.close()
        that.selectSpecialsItems()

  selectSpecialsItems: ->
    $.ajax
      url: Store.context + "/api/admin/goodscommend/find"
      type: "GET"
      data: {
        brandId: brandId
      }
      success: (data)->
        items = data.data.result
        if items
          html = ""
          $.each items, (i, item) ->
            id = item.goodsCommendModel.id
            html += '<tr>' +
              '<td>' + item.goodsCommendModel.goodsId + '</td>' +
              '<td>' + item.itemName + '</td>' +
              '<td>' + item.goodsCommendModel.commendSeq + '</td>' +
              '<td class="option-td-value" data-id="' + id + '">' +
              '<a href="javascript:void(0);" class="item-deleted">删除</a></td>' +
              '</tr>'

          $('.special-items-dto').html(html)
        else
          $('.special-items-dto').html("")

  itemDeleted: (event)->
    event.preventDefault()
    id = $(this).parent('.option-td-value').attr('data-id')
    $.ajax
      url: Store.context + "/api/admin/goodscommend/delete"
      type: "POST"
      data: {
        id: id
      }
      success: (data)->
        that.selectSpecialsItems()

  passed: (evt) ->
    evt.preventDefault()
    data = $(".brand-detail-form").serialize()
    $("form.brand-detail-form").validator
      isErrorOnParent: true

    slide3Id = $('input[name=slide3Id]').val()
    slide4Id = $('input[name=slide4Id]').val()
    slide5Id = $('input[name=slide5Id]').val()
    if slide3Id.length>0
      if that.checkRate(slide3Id)
        $('.slide3').hide()
      else
        $('.slide3').show()
        $('input[name=slide3Id]').val("")
        return
    if slide4Id.length>0
      if that.checkRate(slide4Id)
        $('.slide4').hide()
      else
        $('.slide4').show()
        $('input[name=slide4Id]').val("")
        return
    if slide5Id.length>0
      if that.checkRate(slide5Id)
        $('.slide5').hide()
      else
        $('.slide5').show()
        $('input[name=slide5Id]').val("")
        return

    $.ajax
      url: Store.context + "/api/admin/brand/add-brand-detail"
      type: "POST"
      data: data
      success: (data)->
        window.location.href = Store.context + "/mall/brands/brands-info-all"
#
#  findBrandType: ->
#    $.ajax
#      url: Store.context + "/api/admin/brand/findBrandType"
#      type: "GET"
#      success: (data)->
#        typeList = data.data
#        if typeList
#          $('.brand-type').append('<option value="">请选择</option>')
#          for item, i in typeList
#            html = '<option value="' + item.categoryId + '">' + item.categoryName + '</option>'
#            $('.brand-type').append(html)
#
#          $('.brand-type').val($('.brand-type-id').val())

  checkRate:(value)->
    re = /^[0-9]\d*$/
    if re.test(value)
      return true

module.exports = itemReviewDetail

