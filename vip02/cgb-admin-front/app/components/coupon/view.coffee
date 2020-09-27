Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"
class coupon
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
    @couponSetting = ".js-coupon-setting"
    @couponStatistics = ".js-coupon-statistics"
    @tradeRoleNew = "js-item-create"
    @typeNew = "js-type-new"
    @supplierNew = "js-supplier-new"
    @bindEvent()
  settingTemplate = App.templates["coupon_setting"]
  statisticsTemplate = App.templates["coupon_statistics"]
  supplierTemplate = App.templates["coupon_supplier"]
  typeTemplate = App.templates["coupon_type"]
  that = this

  bindEvent: ->
    that = this
    $(".coupons").on "click", @couponSetting, @settingCoupon
    $(".coupons").on "click", @couponStatistics, @statisticsCoupon
    $(document).on "click",".js-supplier-new",@supplierChoose
    $(document).on "click",".js-type-new",@typeChoose
    $(document).on "click",".js-type-new",@tree_init1
#    $(".coupons").on "click", @supplierNew, @supplierChoose
#    $(".coupons").on "click", @typeNew, @typeChoose
#    $(".coupons").on "click",@tradeRoleNew,@editConfirm
  tree_init1: ->
    $.fn.zTree.init($("#treeDemo"), setting, zNodes)
  setting =
    data:
      simpleData:
        enable: true
        idKey: "id"
        pIdKey: "pId"
        rootPId: ""
    check:
      enable:true

  zNodes = [
    {
      id: 1
      pId: 0
      name: '随意勾选 1'
    }
    {
      id: 2
      pId: 0
      name: '随意勾选 2'
    }
    {
      id: 11
      pId: 1
      name: '随意勾选 1-1'
    }
    {
      id: 111
      pId: 11
      name: '随意勾选 1-1-1'
    }
    {
      id: 22
      pId: 2
      name: '随意勾选 2-2'
    }
    {
      id: 221
      pId: 22
      name: '随意勾选 2-2-1'
    }
    {
      id: 222
      pId: 22
      name: '随意勾选 2-2-2'
    }
  ]


  settingCoupon: ->
    data = $(@).closest("tr").data("data")
    coupon = new Modal(settingTemplate(data)).show()




  editConfirm: (event)->
#    $("form.item-form").validator();
#    event.preventDefault()
    $.ajax
      url: Store.context + "/api/admin/coupon"
      type: "PUT"
      data: (data)->
        data.params = {}
        data.params.id = $.trim($("#sid").val())
        data.params.couponName = $.trim($("#sname").val())
        data.params.couponUser = $.trim($("#suser").val())
        data.params.couponType = $.trim($("#stype").val())
      success: (data)->
        window.location.reload()
  statisticsCoupon: ->
    data = $(@).closest("tr").data("data")
    coupon = new Modal(statisticsTemplate(data)).show()
  supplierChoose: ->
       new Modal(supplierTemplate({})).show()
  typeChoose: ->
    new Modal(typeTemplate({})).show()


module.exports = coupon

