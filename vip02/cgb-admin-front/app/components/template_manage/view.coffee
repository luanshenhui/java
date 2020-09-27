Modal = require "spirit/components/modal"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"

newShopTemplate = App.templates.shop_template_update
editShopTemplate = App.templates._shop_template_item

class TemplateManage
  _.extend @::, TipAndAlert

  constructor: ->
    @shopTemplateRelease = ".js-template-release"
    @shopTemplateEdit = ".js-template-edit"
    @jsTemplateNew = ".js-template-new"
    @bindEvent()
  that = this
  bindEvent: ->
    that = this
    $(@shopTemplateEdit).on "click", @editShopTemplate
    $(document).on "confirm:release-template", @releaseShopTemplate
    $(@jsTemplateNew).on "click", @addTemplate

  addTemplate: ->
    new Modal(newShopTemplate({})).show()
    $(".shop-template-form").validator({
      isErrorOnParent: true
    })
    $(".shop-template-form").on "submit", ->
      $.ajax
        url: Store.context + "/api/admin/sites/templates"
        type: "POST"
        data: $(".shop-template-form").serialize()
        success: ->
          window.location.reload()
        error: (data)->
          new Modal(
            icon: "error"
            title: "出错啦"
            content: data.responseText
          ).show()

  editShopTemplate: ->
    data = $(@).closest("tr").data("template")
    new Modal(newShopTemplate(data)).show()
    $(".form").validator({
      isErrorOnParent: true
    })
    $(".form").on "submit", that.updateShopTemplate

  updateShopTemplate: (evt)->
    evt.preventDefault()
    siteId = $(@).attr "template-id"
    $.ajax
      url: Store.context + "/api/admin/sites/#{siteId}"
      type: "PUT"
      data: $(".shop-template-form").serialize()
      success: (data)->
        window.location.reload()

  releaseShopTemplate: (evt, data)->
    template = $(".template[data-id=#{data}]").data("template")
    templateId = template.id
    designTemplateId = template.designInstanceId
    $.ajax
      url: Store.context + "/api/admin/sites/announcement/#{templateId}/release"
      type: "POST"
      data: {"instanceId": designTemplateId}
      success: =>
        that.alert "body", "success", "发布成功！", "模板生效需要一定时间，请继续其他操作！"
        left = $(window).width() / 2 - $(".alert").width() / 2
        top = $(window).height() / 2 - $(".alert").height() / 2
        $(".alert").css("left", left).css("top", top)

module.exports = TemplateManage

