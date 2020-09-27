TipAndAlert = require "tip_and_alert/tip_and_alert"
Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"

class UserImage
  _.extend @::, TipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show(56)

  constructor: ->
    @$tab = @$el
    @$jsImageUpload = $(".js-image-upload")
    @$jsClip = $(".js-clip")
    @bindEvent()

  that = this
  bindEvent: ->
    that = this
    @$tab.tab()
    @$jsImageUpload.on "click", @imagesUpload
    @$jsClip.on "click", @clip

  clip: ->
    that.$jsClip.zclip
      path: "/vendor/scripts/ZeroClipboard.swf"
      copy: ->
        return $(@).data("url")
      beforeCopy: ->
        $(@).css("color", "#F08A09")
      afterCopy: ->
        that.alert "body", "success", "复制成功！", "图片路径：" + $(@).data("url")

  imagesUpload: (evt)->
    $(".js-image-upload").fileupload
      url: Store.context + "/api/images/upload"
      dataType: "json"
      done: (e, result) =>
        location.href = Store.context + "/images"
      success: (data)->
        location.href = Store.context + "/images"
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


module.exports = UserImage

