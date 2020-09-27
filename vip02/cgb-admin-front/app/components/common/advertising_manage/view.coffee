Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"

class AdvertisingManage
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  _.extend @::, TipAndAlert
  constructor: ->
    @advertisingCheck = ".js-advertising-check"
    @advertisingRefuse = ".js-advertising-refuse"
    @advertisingDelete = ".js-advertising-delete"
    @advertisingView = ".js-advertising-view"
    @advertisingViewImag=".js-view-image"


    @bindEvent()
  that = this
  advertisingRefuseTemplate = App.templates["advertising_refuse"]

  bindEvent: ->
    $(".advertising-manage").on "click", @advertisingCheck, @checkAdvertising
    $(".advertising-manage").on "click", @advertisingRefuse, @refuseAdvertising
    $(".advertising-manage").on "click", @advertisingView, @viewAdvertising
    $(".advertising-manage").on "mouseover", @advertisingViewImag, @advertisingViewImageIn
    $(".advertising-manage").on "mouseleave", @advertisingViewImag, @advertisingViewImageOut
    $(document).on "confirm:delete-advertising",  @deleteAdvertising
    that = this

  checkAdvertising: ->
    id = $(@).closest("tr").data("id")
    $.ajax
      url: Store.context + "/api/admin/advertising/advertisingCheck"
      type: "POST"
      data: {
        id: id
      }
      success: (data)->
        window.location.href = Store.context + "/common/advertising-manage"

  refuseAdvertising: ->
    result = $(@).closest("tr").data("data")
    new Modal(advertisingRefuseTemplate({data: result})).show()
    $("form.advertising-refuse-form").validator
      isErrorOnParent: true
    $("form.advertising-refuse-form").on "submit", that.refuseAd

  refuseAd: (evt)->
    evt.preventDefault()
    $("form.sms-template-form").validator
      isErrorOnParent: true
    id = $("#refuseId").val()
    refuseDetail = $("#refuseDetail").val()
    $.ajax
      url: Store.context + "/api/admin/advertising/advertisingRefuse"
      type: "POST"
      data: {
        id: id,
        refuseDetail: refuseDetail,
      }
      success: (data)->
        window.location.href = Store.context + "/common/advertising-manage"

  deleteAdvertising: (evt, data)->
    id = data
    $.ajax
      url: Store.context + "/api/admin/advertising/advertisingDelete"
      type: "POST"
      data: {
        id: id
      }
      success: (data)->
        window.location.href = Store.context + "/common/advertising-manage"

  viewAdvertising: ->
    result = $(@).closest("tr").data("data")
    if result.media
      html = '<div class="pop-up-ad" style="display: block;" onclick="$(\'.pop-up-ad\').remove()">'
      html = html + '<img width="840px" height="219px"class="img-center-ad" src='
      html = html + (result.media)
      html = html + '></div>'
      $("body").append(html)
    else
      that.alert "body", "success", "该条广告没有上传图片"

  advertisingViewImageIn: (e) ->
    $(".pop-img").hide()
    id= $(@).closest("tr").data("id")
    $(".pop-img[data-id=" + id + "]").show()
  advertisingViewImageOut:->
    $(".pop-img").hide()

module.exports = AdvertisingManage
