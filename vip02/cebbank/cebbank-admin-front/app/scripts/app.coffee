require "spirit"
require "extras/handlebars"
require "extras/ajax"
Store = require "extras/store"

module.exports =
  
  init: ->
    require("spirit/components/component").init()

    $("img[data-original]").lazyload
      effect: "fadeIn"

    $(".datepicker").datepicker()

    $("#js-logout").on "click", ->
      $.ajax
        url: Store.context + "/api/admin/user/logout"
        type: "GET"
        success: ->
          window.location.href = Store.context + "/login"

