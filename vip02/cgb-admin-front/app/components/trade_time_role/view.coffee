Modal = require "spirit/components/modal"
Store = require "extras/store"
Pagination = require "spirit/components/pagination"
class tradeTimeRole
  constructor: ->
    @tradeRoleNew = ".js-trade-role-new"
    @bindEvent()

  bindEvent: ->
    $(".tradeTimeRole").on "click", @tradeRoleNew, @createTradeRole

  createTradeRole: (evt)->
    evt.preventDefault()
    ids = ""

    json={}
    jsonA=[]
    $(".trade-time").each ->
      $(@).find("td").each (i, n)->
#      json.id = $(@).data("id")
#      console.log(json.id)
      ids += $(@).closest("tr").data("id")
      $(@).find("input[type='text']").each (i, n)->

        ids += ":"
        ids += n.value

        if i == 1
          ids += ","



        json[n.name]=n.value;
#        jsonA = [json = {}]
        json.end = $(@)[0].value
        jsonA.push("end",json.end)

        json.warn = $(@)[0].value
        jsonA.push("warn",json.warn)
#        json.warn = $(@)[i+1].value
    ids = ids.substring(0, ids.length - 1);

#    params2 = JSON.stringify(ids)

    $.ajax
      url: Store.context + "/api/admin/tradeTimeRole/#{ids}"
      type: "PUT"
      dataType: "JSON"
      success: (data)->
        window.location.reload()
module.exports = tradeTimeRole
