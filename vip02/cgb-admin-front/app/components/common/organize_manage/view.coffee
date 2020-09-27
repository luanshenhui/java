Modal = require "spirit/components/modal"
tipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"
organizeAddTemplate = App.templates.orginaze_new

class Organize
  _.extend @::, tipAndAlert
  constructor: ->
    @$jsOrganizeNew = $(".js-organize-new")
    @$organiseForm = $(".organise-form")
    @$jsOrgEdit = $(".js-org-edit")
    @$jsOrgDel = $(".js-org-del")
    @remainingTarget = ".remaining-target"

    @bindEvent()
  that = this

  bindEvent: ->
    that = this
    @$jsOrganizeNew.on "click", @organizeAdd
    @$jsOrgEdit.on "click", @organizeEdit
    $(document).on "confirm:delete-org", @organizeDel
    $(document).on "keyup", @remainingTarget, @remainingText
    $(document).on "blur", @remainingTarget, @remainingText

  organizeDel: (evt, data)->
    id = data
    $.ajax
      url: Store.context + "/api/admin/org/delete/#{id}"
      type: "POST"
      dataType: "JSON"
      success: (data)=>
        window.location.reload();
      error: (data) ->
        new Modal(
          icon: "error"
          title: "出错啦！"
          content: data.responseText || "未知故障"
          overlay: false)
        .show()

  organizeEdit: ->
    data = $(@).closest("tr").data("data")
    new Modal(organizeAddTemplate({title: "编辑机构", data: data})).show()
    that.remainingText()
    $("form.organise-form").validator
      isErrorOnParent: true
    $("form.organise-form").on "submit", that.organiseFormUpdate

  organiseFormUpdate: (evt) ->
    evt.preventDefault();
    id = $("form.organise-form").data("id")
    $("form.organise-form").validator
      isErrorOnParent: true
    $.ajax
      url: Store.context + "/api/admin/org/edit/#{id}"
      type: "POST"
      data: $("form.organise-form").serialize()
      success: (data)->
        window.location.reload()
      error: (data) ->
        new Modal(
          icon: "error"
          title: "出错啦！"
          content: data.responseText || "未知故障"
          overlay: false)
        .show()

  organizeAdd: ->
    new Modal(organizeAddTemplate({title: "新增机构",add:true})).show()
    $("form.organise-form").validator
      isErrorOnParent: true
    $("form.organise-form").on "submit", that.organiseFormSubmit

  organiseFormSubmit: (evt)->
    evt.preventDefault();
    $("form.organise-form").validator
      isErrorOnParent: true
    $.ajax
      url: Store.context + "/api/admin/org/add"
      type: "POST"
      data: $("form.organise-form").serialize()
      success: (data)->
        if data.data is true
          window.location.reload()
        else
          that.alert "body", "error", "机构代码已存在或被使用过"

      error: (data) ->
        new Modal(
          icon: "error"
          title: "出错啦！"
          content: data.responseText || "未知故障"
          overlay: false)
        .show()

  remainingText: ->
    val = $("#descript").val()
    length = parseInt(val.length)
    text = 200 - length
    if length >= 200
      $(@).val(val.substr(0, 200))
      text = 0
    $(".remaining-text i").text(text)

module.exports = Organize