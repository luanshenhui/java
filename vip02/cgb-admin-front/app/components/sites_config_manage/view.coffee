Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"

class sitesConfig
  _.extend @::, TipAndAlert

  constructor: ->
    @sitesConfigNew = ".js-sites-new"
    @sitesConfigDelete = ".js-sites-delete"
    @sitesConfigEdit = ".js-sites-config-edit"
    @bindEvent()
  sitesTemplate = App.templates.sites_config_detail
  that = this
  bindEvent: ->
    that = this
    @setDomain()
    $(".sites-config").on "click", @sitesConfigNew, @sitesNew
    $(document).on "confirm:delete-site", @sitesDelete
    $(".sites-config").on "click", @sitesConfigEdit, @sitesEdit
    $(document).on "confirm:release-site", @releaseSite
    new Pagination(".site-pagination").total($(".sites-config").data("total")).show(20)

  sitesNew: ->
    new Modal(sitesTemplate({domain: $(".sites-config").data("domain")})).show()
    $(".sites-form").validator({
      isErrorOnParent: true
    })
    $(".sites-form").on "submit", ->
      if $("#sites-id").val().length>10
        that.alert "body", "error", "提示信息！", "输入站点名字不能超过10个字！"
        return
      $.ajax
        url: Store.context + "/api/admin/sites/add"
        type: "POST"
        data: $(".sites-form").serialize()
        success: ->
          $(".sites-form").serialize()
          window.location.reload()
        error: (data)->
          new Modal(
            icon: "error"
            title: "出错啦"
            content: data.responseText
            overlay:false
          ).show()

  setDomain: ->
    mainSite = $(".sites-config").data("domain")
    domain = mainSite.split(".")[1..].join(".")
    $(".sites-config").data("domain", domain)
    _.each $(".sites-config-domain"), (domainTd)->
      subdomain = $(domainTd).find("a").attr "href"
      context = $(domainTd).find("a").data("context")
      if context?
        context =　"/" + context
      else
        context = ""
      $(domainTd).find("a").attr "href", "http://" + subdomain + "." + domain + context
      $(domainTd).find("a").text subdomain + "." + domain

  sitesDelete: (evt, data)->
    sitesId = data
    $.ajax
      url: Store.context + "/api/admin/sites/delete/#{sitesId}"
      type: "POST"
      success: ->
        window.location.reload()
      error: (data)->
        new Modal(
          icon: "error"
          title: "出错啦"
          content: data.responseText
        ).show()

  sitesEdit: ->
    sitesData = $(@).closest("tr").data("sites-config")
    new Modal(sitesTemplate({
      data: sitesData,
      domain: $(".sites-config").data("domain"),
      userType: $(".sites-config").data("user-type")
      edit:true
    })).show()
    $(".sites-form").validator
      isErrorOnParent: true
    $(".sites-form").on "submit", ->
      siteId = $(@).attr("sites-id")
      if $("#sites-id").val().length>10
        that.alert "body", "error", "提示信息！", "输入站点名字不能超过10个字！"
        return
      $.ajax
        url: Store.context + "/api/admin/sites/edit/#{siteId}"
        type: "POST"
        data: $(@).serialize()
        success: ->
          window.location.reload()
        error: (data)->
          new Modal(
            icon: "error"
            title: "出错啦"
            content: data.responseText
          ).show()

  releaseSite: (evt, data)->
    site = $(".site[data-id=#{data}]").data("sites-config")
    siteId = data
    designTemplateId = site.designInstanceId
    $.ajax
      url: Store.context + "/api/admin/sites/announcement/#{siteId}/release"
      type: "POST"
      data: {"instanceId": designTemplateId}
      success: =>
        that.alert "body", "success", "发布成功！", "模板生效需要一定时间，请继续其他操作！"
        left = $(window).width() / 2 - $(".alert").width() / 2
        top = $(window).height() / 2 - $(".alert").height() / 2
        $(".alert").css("left", left).css("top", top)
      error: (data)->
        new Modal(
          icon: "error"
          title: "出错啦"
          content: data.responseText
        ).show()

module.exports = sitesConfig
