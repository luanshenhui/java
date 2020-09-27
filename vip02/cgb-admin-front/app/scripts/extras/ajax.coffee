Modal = require "spirit/components/modal"
Store = require "extras/store"
$.ajaxSetup
  cache: false
  error: (jqXHR, textStatus, errorThrown) ->
    if jqXHR.status is 401
      window.location.href = Store.context + "/login"
    else
      new Modal(
        "icon": "error"
        "title": "友情提示"
        "content": jqXHR.responseText || "未知故障"
        "overlay": false
      ).show()
    $("body").spin(false)
