Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"
TipAndAlert = require "tip_and_alert/tip_and_alert"
whiteList = App.templates['white_list']
class whiteListAllocation
  _.extend @::, TipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
    @whiteAdd = ".js-white-add"
    @whiteEdit = ".js-white-edit"
    @bindEvent()
  that = this
  bindEvent: ->
    that = this
    $(".white-list-allocation").on "click", @whiteAdd, @addWhite
    $(".white-list-allocation").on "click", @whiteEdit, @editWhite
    $(document).on "confirm:delete-white", @deleteWhite

#新增
  addWhite: ->
    data = null
    addWhiteModel = new Modal whiteList({data: data})
    addWhiteModel.show()
    $("form.white-list-form").validator
      isErrorOnParent: true
    $("form.white-list-form").on "submit", that.addWhiteConfirm

  addWhiteConfirm: (evt) ->
    evt.preventDefault()
    $("form.white-list-form").validator
      isErrorOnParent: true
    linkUrl = $(".js-linkUrl-input").val()
    type = $("#type").val()
    if linkUrl != ""
      $.ajax
        url: Store.context + "/api/admin/whiteList/findLinkUrl"
        type: "POST"
        data: linkUrl:linkUrl,type:type
        success: (data)->
          if data.data.result is false
            that.tip $(".js-linkUrl-input").parent(), "error", "up", "白名单已存在！"
            $(".tip").css("left", 137).css("top", 36)
            return
          else
            data = $(".white-list-form").serialize()
            $.ajax
              url: Store.context + "/api/admin/whiteList/insertAqInf"
              type: "POST"
              data: data
              success: (data)->
                window.location.reload()

#修改
  editWhite: ->
    data = $(@).closest("tr").data("list")
    editWhiteModel = new Modal whiteList({data: data})
    editWhiteModel.show()
    $("form.white-list-form").validator
      isErrorOnParent: true
    $("form.white-list-form").on "submit", that.editWhiteConfirm

  editWhiteConfirm: (evt) ->
    evt.preventDefault();
    $("form.white-list-form").validator
      isErrorOnParent: true
    linkUrl = $(".js-linkUrl-input").val()
    type = $("#type").val()
    if linkUrl != ""
      $.ajax
        url: Store.context + "/api/admin/whiteList/findLinkUrl"
        type: "POST"
        data: linkUrl:linkUrl,type:type
        success: (data)->
          if data.data.result is false
            that.tip $(".js-linkUrl-input").parent(), "error", "up", "白名单已存在！"
            $(".tip").css("left", 137).css("top", 36)
            return
          else
            data = $(".white-list-form").serialize()
            $.ajax
              url: Store.context + "/api/admin/whiteList/updateAqInf"
              type: "POST"
              data: data
              success: (data)->
                window.location.reload()

#删除
  deleteWhite: (event, data)->
    event.preventDefault()
    $.ajax
      url: Store.context + "/api/admin/whiteList/" + data
      type: "DELETE"
      success: (data)->
        window.location.reload()

module.exports = whiteListAllocation
