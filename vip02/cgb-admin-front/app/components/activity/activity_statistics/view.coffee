Pagination = require "spirit/components/pagination"
Store = require "extras/store"

class activity_statistics
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  startpicker = new Pikaday({field: $(".js-date-start")[0]});
  endpicker = new Pikaday({field: $(".js-date-end")[0]});

  constructor: ->
    @bindEvent()
    @idInit()

  bindEvent: ->
    $(document).on "click", (".activity-name"), @activityNameClick
    $(document).on "click", (".activity-item"), @activityItemClick

  idInit: ->
    $("#promId").val($.query.get("promId"))

  # 点击 活动名称
  activityNameClick: ->
    id = $(@).closest("tr").data("id")
    window.open(Store.context + "/mall/activity/activity-detail?promotionId="+id)

  #点击  单品名称
  activityItemClick: ->
    itemCode = $(@).closest("tr").data("data").selectCode
    goodsCode= $(@).closest("tr").data("data").goodsCode
    url=$(@).closest("tbody").data("url")
    window.open(url+"/mall/goods/"+goodsCode+"?itemCode="+itemCode)

module.exports = activity_statistics

