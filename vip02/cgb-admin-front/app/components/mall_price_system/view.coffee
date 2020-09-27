Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"
tipAndAlert = require "tip_and_alert/tip_and_alert"

class MallPriceSystem
  _.extend @::, tipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
    @discountNew = ".js-discount-add"
    @discountUpdate = ".js-discount-edit"


    @bindEvent()
  that = this
  pointsDiscountTemplate = App.templates["points_discount_add"]

  bindEvent: ->
#    新增
    $(".price-system").on "click", @discountNew, @newDiscount
#    编辑
    $(".price-system").on "click", @discountUpdate, @updateDiscount
#    删除
    $(document).on "confirm:delete-discount",  @deleteDiscount
    that = this

  newDiscount: ->
    new Modal(pointsDiscountTemplate({title:"金普卡积分系数新增"})).show()
    $("form.points-discount-form").validator
      isErrorOnParent: true
    $("form.points-discount-form").on "submit", that.discountAdd

  updateDiscount: ->
    data = $(@).closest("tr").data("data")
    new Modal(pointsDiscountTemplate({title:"金普卡积分系数编辑",data: data})).show()
    $("form.points-discount-form").validator
      isErrorOnParent: true
    $("form.points-discount-form").on "submit", that.discountEdit

  discountAdd: (evt)->
    evt.preventDefault()
    $("form.points-discount-form").validator
      isErrorOnParent: true
    $(".downLimit-required-error").remove() #基础下限
    $(".upLimit-required-error").remove() #基础上限
    $(".argumentNormal-required-error").remove() #金普卡参数
    result = $("form.points-discount-form").serializeObject()
#    校验开始
    if !/^[0-9]\d*$/.test result.downLimit #基础下限
      $("#downLimit").parent().append("<span class=\"downLimit-required-error error-class required\"><i>&times;</i> 请输入正整数</span>")
      return
    if !/^[1-9]\d*$/.test result.upLimit #基础上限
      $("#upLimit").parent().append("<span class=\"upLimit-required-error error-class required\"><i>&times;</i> 请输入正整数</span>")
      return
    if !/^([1-9]\d{0,15}|0)(\.\d{1,4})?$/.test result.argumentNormal
      $("#argumentNormal").parent().append("<span class=\"argumentNormal-required-error error-class required\"><i>&times;</i> 请输入0～1最多4位小数</span>")
      return
    if result.argumentNormal < 0 or result.argumentNormal is 0 or result.argumentNormal > 1
      $("#argumentNormal").parent().append("<span class=\"argumentNormal-required-error error-class required\"><i>&times;</i> 请输入0～1最多4位小数</span>")
      return

#    查询数据库中在所有上限值，取其最大值来判断下限值是否正确
    downLimit = result.downLimit
    $.ajax
      url: Store.context + "/api/admin/priceSystem/findUpLimitMax"
      type: "GET"
      success: (data)->
        upLimitMax = data.data
        if downLimit != upLimitMax
          that.alert "body", "error", "基础下限值设置有误！"
          return false
#    校验结束

        $.ajax
          url: Store.context + "/api/admin/priceSystem/add"
          type: "POST"
          data: result
          success: (data)->
            window.location.reload()

  discountEdit: (evt)->
    evt.preventDefault()
    $("form.points-discount-form").validator
      isErrorOnParent: true
    $(".argumentNormal-required-error").remove() #金普卡参数

    result = $("form.points-discount-form").serializeObject()
    #    校验开始
    if !/^([1-9]\d{0,15}|0)(\.\d{1,4})?$/.test result.argumentNormal
      $("#argumentNormal").parent().append("<span class=\"argumentNormal-required-error error-class required\"><i>&times;</i> 请输入0～1最多4位小数</span>")
      return
    if result.argumentNormal < 0 or result.argumentNormal is 0 or result.argumentNormal > 1
      $("#argumentNormal").parent().append("<span class=\"argumentNormal-required-error error-class required\"><i>&times;</i> 请输入0～1最多4位小数</span>")
      return
    #    校验结束
    $.ajax
      url: Store.context + "/api/admin/priceSystem/edit"
      type: "POST"
      data: result
      success: (data)->
        window.location.reload()

  deleteDiscount: (evt, data)->
    componentId = data
    $.ajax
      url: Store.context + "/api/admin/priceSystem/delete"
      type: "POST"
      data: {
        id: componentId
      }
      success: (data)=>
        $("tr[data-id=#{componentId}]").remove()
        window.location.href = Store.context + "/mall/price-system/points-ratio"



module.exports = MallPriceSystem
