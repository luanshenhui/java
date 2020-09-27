Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"
tipAndAlert = require "tip_and_alert/tip_and_alert"

class publishManage
  _.extend @::, tipAndAlert
  #分页
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
    #点击发布公告
#    @publishAdd = ".js-publish-add"
    #点击查看
#    @publishView =".js-publish-view"
    @publishOnOff = ".publish-onoff" #启用、停用公告
    @$el.find(".datepicker").datepicker()
    @bindEvent()
  that = this

  bindEvent: ->
    that = this
    $(".publishManage").on "click", @publishOnOff, @onoffPublish
#    $(".publishManage").on "click", @publishAdd, @addPublish
#    $(".publishManage").on "click", @publishView, @viewPublish

  onoffPublish: ->
#获取渠道
    #获取商品编码
    code = $(@).parent().parent().data("id")
    #获取当前状态值
    state = $(@).parent().data("state")
    $.ajax
      url: Store.context + "/api/admin/publish/updatePublishStatus"
      type: "POST"
      data:
        code: code, state: state
      success: (data)->
#        that.alert "body", "success", "状态修改成功！"
        window.location.reload()
      

  #跳转新增页
#  addPublish :->
#    location.href = Store.context + "publish_add"

  #公告查看
#  viewPublish: ->
#    publishId = $(@).closest("tr").data("id")
#    location.href = Store.context + "publish_view?id=" + publishId

module.exports = publishManage