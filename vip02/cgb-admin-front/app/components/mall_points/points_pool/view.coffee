Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"

class PointsPool
  new Pagination(".pagination").total($(".pagination").data("total")).show();
  constructor: ->
    @bindEvent()
  that = this
  pointpoolTemplate = App.templates["pool_add_edit"]


  bindEvent: ->
    that = this
    $(".js-pool-new").on "click", @addPointPool
    $(".js-pool-edit").on "click", @updatePointPool
    $(document).on "confirm:delete-pool", @deletePointPool
    $(".js-all-check").on "click", @checkAll


  addPointPool: ->
    addModal = new Modal pointpoolTemplate({})
    addModal.show()
    $("form.point-pool-form").validator
      isErrorOnParent: true
    $("form.point-pool-form").on "submit", that.pointPoolAdd

  pointPoolAdd: (evt)->
    evt.preventDefault()
    $("form.point-pool-form").validator
      isErrorOnParent: true
    #校验
    formObject = $("form.point-pool-form").serializeObject()
    $(".curMonth-required-error").remove() #月份
    $(".curMonthCheck-required-error").remove() #月份唯一性
    $(".maxPoint-required-error").remove() #当月最高积分
    $(".singlePoint-required-error").remove() #单位积分
    $(".pointRate-required-error").remove() #最高倍率

    if !/^(\d{4})(0\d{1}|1[0-2])$/.test formObject.curMonth #月份
      $("#curMonth").parent().append("<span class=\"curMonth-required-error required\"><i>&times;</i>请输入年+月:例如201601</span>")
      return

    if !/^[1-9]\d*$/.test formObject.maxPoint #当月最高积分
      $("#maxPoint").parent().append("<span class=\"maxPoint-required-error required\"><i>&times;</i>请输入正整数</span>")
      return

    if !/^[1-9]\d*$/.test formObject.singlePoint #单位积分
      $("#singlePoint").parent().append("<span class=\"singlePoint-required-error required\"><i>&times;</i>请输入正整数</span>")
      return
    numval = Number(formObject.pointRate)
    slId = $.trim(formObject.pointRate)
    if isNaN(numval) || numval<0 || numval>1 ||slId == ""
      $("#pointRate").parent().append("<span class=\"pointRate-required-error required\"><i>&times;</i>请输入0,1或正小数</span>")
      return

    #月份唯一性校验
    curMonth = formObject.curMonth
    $.ajax
      url:Store.context + "/api/admin/pointPool/add-check"
      type:"POST"
      data:{
        curMonth:curMonth
      }
      success: (result)->
        if result.data.result==1
          $("#curMonth").parent().append("<span class=\"curMonthCheck-required-error required\"><i>&times;</i> 该月份已存在</span>")
          return false

        $.ajax
          url: Store.context + "/api/admin/pointPool/add"
          type: "POST"
          data: $("form.point-pool-form").serializeObject()
          success: (data)->
            window.location.reload()
          error: (data) ->
            new Modal(
              icon: "error"
              title: "出错啦！"
              content: data.responseText || "未知故障"
              overlay: false)
            .show()

  updatePointPool: ->
#    thisPool = $(@).closest("tr").data("data")
#    editModal = new Modal pointpoolTemplate(thisPool)
#    editModal.show()
    flag = $(@).data("flag")
    thisPool = $(@).closest("tr").data("data")
    new Modal(pointpoolTemplate({title:"edit",data: thisPool})).show()
    if flag+"" is "0"
      $("#singlePoint").attr("readonly",true)
      $("#pointRate").attr("readonly",true)
    $("form.point-pool-form").validator
      isErrorOnParent: true
    $("form.point-pool-form").on "submit", that.pointPoolUpdate

  pointPoolUpdate: (evt)->
    evt.preventDefault()
    $("form.point-pool-form").validator
      isErrorOnParent: true

    #校验
    formObject = $("form.point-pool-form").serializeObject()
    $(".maxPoint-required-error").remove() #当月最高积分
    $(".singlePoint-required-error").remove() #单位积分
    $(".pointRate-required-error").remove() #最高倍率


    if !/^[1-9]\d*$/.test formObject.maxPoint #当月最高积分
      $("#maxPoint").parent().append("<span class=\"maxPoint-required-error required\"><i>&times;</i>请输入正整数</span>")
      return

    if !/^[1-9]\d*$/.test formObject.singlePoint #单位积分
      $("#singlePoint").parent().append("<span class=\"singlePoint-required-error required\"><i>&times;</i>请输入正整数</span>")
      return

    numval = Number(formObject.pointRate)
    slId = $.trim(formObject.pointRate)
    if isNaN(numval) || numval<0 || numval>1 || slId == ""#最高倍率
      $("#pointRate").parent().append("<span class=\"pointRate-required-error required\"><i>&times;</i>请输入0,1或正小数</span>")
      return

    $.ajax
      url: Store.context + "/api/admin/pointPool/edit"
      type: "POST"
      data: $("form.point-pool-form").serializeObject()
      success: (data)->
        window.location.reload()
      error: (data) ->
        new Modal(
          icon: "error"
          title: "出错啦！"
          content: data.responseText || "未知故障"
          overlay: false)
        .show()

  deletePointPool:(evt, data) ->
    componentId = data
    $.ajax
      url: Store.context + "/api/admin/pointPool/delete"
      type: "POST"
      data:{
          id: componentId
      }
      success: (data)=>
        window.location.reload()
      error: (data)->
        new Modal(
          icon: "error"
          title: "出错啦！"
          content: data.responseText || "未知故障"
          overlay: false)
        .show()


module.exports = PointsPool