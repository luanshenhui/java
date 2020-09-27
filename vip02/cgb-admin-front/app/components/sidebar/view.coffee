Modal = require "spirit/components/modal"
Store = require "extras/store"

class Sidebar
  front = null
  back = null
  manageComp = null
  constructor: ->
    @sidebarSelect = $(".f-link>li>a")
    @sidebarSelectSub = $(".t-link>li>a")
    @sidebarAuth = $(".inner-item-a[data-auth]")
    @getLocal()
    @bindEvent()

  bindEvent: ->
    @sidebarSelect.on "click", @selectMenu
    @sidebarSelectSub.on "click", @selectMenuSub
    @sidebarAuth.on "click", @sidebarAuthFn

  selectMenu: ->
    $(@).siblings(".t-link").toggle(100)
    $(".side a").removeClass "on"
    $(@).addClass "on"
    if $(@).find("i").hasClass("fa-plus-square")
      $(@).find("i").removeClass("fa-plus-square").addClass("fa-minus-square")
    else
      $(@).find("i").removeClass("fa-minus-square").addClass("fa-plus-square")

  selectMenuSub: ->
    $(@).siblings(".s-link").toggle(100)
    $(".side a").removeClass "on"
    $(@).addClass "on"
    if $(@).find("i").hasClass("fa-plus-square")
      $(@).find("i").removeClass("fa-plus-square").addClass("fa-minus-square")
    else
      $(@).find("i").removeClass("fa-minus-square").addClass("fa-plus-square")
#    $(@).parents(".f-menu").children("a").addClass "on"

  sidebarAuthFn: (event) ->
    event.preventDefault()
    _this = $(@)
    $.ajax
      url: Store.context + "/api/admin/members/has_permissions/#{$(@).data("auth")}"
      type: "GET"
      success: (data) ->
        if data.data
          window.location.href = _this.attr("href")
        else
          new Modal(
            icon: "info"
            title: "温馨提示："
            content: "您可能没有权限访问该选项，如有异议，请联系系统管理员。"
          ).show ->
            _this.addClass "disabled"
      error: (data) ->
        window.location.href = _this.attr("href")

  getLocal: ->
    local = window.location.pathname
    $(".side a").each (i, el) ->
      paths = _.union([], $(el).data("paths"))
      paths.push($(el).attr("href"))
      if $.inArray(local, paths) isnt -1
        $(".side a").removeClass "on"
        #$(el).closest(".f-link>li>a").addClass "on"
        #        $(el).parents(".f-menu").children("a").addClass "on"
        $(el).addClass "on"
        $(el).parents(".f-menu").children(".t-link").show()
        $(el).parents(".s-link").show();

        $(el).parents(".s-link").parent("li").find("a").find("i").removeClass("fa-plus-square").addClass("fa-minus-square")

        return false

module.exports = Sidebar