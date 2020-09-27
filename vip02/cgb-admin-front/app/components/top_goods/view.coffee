Pagination = require "spirit/components/pagination"
Modal = require "spirit/components/modal"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"

TopGoodsAdd = App.templates["top_goods_add"]
TopGoodsEdit = App.templates["top_goods_edit"]
liTemplate = App.templates["back_category_item"]
selectItemResultTemp = App.templates['item_select_result'] #选择产品查询结果模板

class TopGoods
  _.extend @::, TipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show(10)
  #  定义二级，三级，四级类目
  result2 = ""
  result3 = ""
  #  result4 = ""
  goryId = "" #最后一级类目的id
  constructor: ->
    @goodsSearch = (".js-search-item")
    @jsTopGoodsAdd = ".js-topgoods-new"
    @jsTopGoodsEdit = ".js-topgoods-edit"
    @jsTopGoodsDelete = ".js-topgoods-delete"
    @backCategoryBtn = ".find-next-category"
    @jsGoodsSearchBtn = ".js-goods-search-btn"
    @bindEvent()
  that = this
  editModal = null
  bindEvent: ->
    that = this
    $(@jsTopGoodsAdd).on "click", @newTopGoods
    $(@jsTopGoodsEdit).on "click", @editTopGoods
    $(document).on "confirm:delete-top", @deleteTopGoods

# 图片搜索
  searchBtnGoodsSearchBtn: ->
    level1 = $(".back-category-list[data-level=1]").find(".clickon").parent().data("id")
    level2 = $(".back-category-list[data-level=2]").find(".clickon").parent().data("id")
    level3 = $(".back-category-list[data-level=3]").find(".clickon").parent().data("id")
    #    level4= $(".back-category-list[data-level=4]").find(".clickon").parent().data("id")
    if level1 is null or level1 is '' or level1 is undefined
      that.alert "error", "请选择一级类目！"
    else
      that.goryId = level1
      if result2 is null and result2 is '' and result2 is undefined
        that.searchGoods()
        return
      else
        if level2 is null or level2 is '' or level2 is undefined
          that.alert "error", "请选择二级类目！"
        else
          that.goryId = level2
          if result3 is null and result3 is '' and result3 is undefined
            that.searchGoods()
            return
          else
            if level3 is null or level3 is '' or level3 is undefined
              that.alert "error", "请选择三级类目！"
            else
              that.goryId = level3
              that.searchGoods()
#              if result4 isnt null and result4 isnt '' and result4 isnt undefined
#                that.searchGoods()
#                return
#              else
#                if level4 is null or level4 is '' or level4 is undefined
#                  TipAndAlert.alert("error","请选四级类目！")
#                else
#                  goryId=level4
#                  that.searchGoods()
  searchGoods: ()->
    ## ！注释 保留
    obj = {}
    keyword = $(".search-item-input.js-search-item").val()
    if keyword is undefined || keyword is null || keyword is ""
      keyword = ""
    obj.keyword = keyword
    $.ajax
      url: Store.context + "/api/admin/topGoods/findGoods/#{that.goryId}"
      data: obj
      type: "GET"
      success: (data)->
        $(".js-item-search-result").html(selectItemResultTemp(data))

# 修改
  editTopGoods: ->
    data = $(@).closest("tr").data("data")
    channelMall = data.goodsModel.channelMall
    channelApp = data.goodsModel.channelApp
    if channelMall isnt "02" or channelApp isnt "02"
      that.alert "body", "error", "商城、app渠道未上架，请先上架！"
      return
    data.code = $(@).closest("tr").data("code")
    data.stickOrder = $(@).closest("tr").data("stickOrder")
    data.name = $(@).closest("tr").data("name")
    editModal = new Modal(TopGoodsEdit({data: data}))
    editModal.show()

    $(".top-goods-edit-modal").on "click", that.jsGoodsSearchBtn, that.searchBtnGoodsSearchBtn
    $(".top-goods-edit-modal").on "click", that.backCategoryBtn, that.findNextCategory
    $("form.topgoods-form-edit").validator
      isErrorOnParent: true
    $("form.topgoods-form-edit").on "submit", that.updateTopGoods

# 添加
  newTopGoods: ->
    $.get Store.context + "/api/admin/backCategories?channel=YG", (data) ->
      new Modal(TopGoodsAdd({data: data})).show()
      $(".top-goods-modal").on "click", that.jsGoodsSearchBtn, that.searchBtnGoodsSearchBtn
      $(".top-goods-modal").on "click", that.backCategoryBtn, that.findNextCategory
      $(".top-goods-modal").on "keyup", that.goodsSearch, that.goodsSearchItem
      $("form.topgoods-form-add").validator
        isErrorOnParent: true
      $("form.topgoods-form-add").on "submit", that.createTopGoods

#点击类目查询数据
  findNextCategory: (event)->
    event.preventDefault()
    ###删除当前被选中的状态###
    $.each($(@).closest("ul").find("li"), ->
      $(@).find("a").removeClass("clickon")
    )
    ###添加当前被选中的状态###
    $(@).addClass("clickon")
    ###获取选中的id###
    id = $(@).closest("li").data("id")
    ###将id存入父级元素ul中 用于下级节点判断父节点###
    $(@).closest("ul").data("select", id)
    ###获取当前的层级 层级数据在标签中写死###
    currentLevel = $(@).closest("ul").data("level")
    if currentLevel is 1
      ###点击第一级节点要把第二级和第三级的data-select清空###
      $("ul[data-level=2]").data("select", null)
      $("ul[data-level=3]").data("select", null)
      $.ajax
        url: Store.context + "/api/admin/goods/look-toAddGdCat"
        type: "POST"
        data:
          id: id
        dataType: "JSON"
        success: (content)->
          ###渲染数据###
          category = liTemplate(content.data)
          ###清空二级和三级节点###
          $("ul[data-level=2]").empty()
          $("ul[data-level=3]").empty()
          ###将渲染的结果拼到页面上###
          $("ul[data-level=2]").append(category)
    if currentLevel is 2
      ###清空三级ul上的select###
      $("ul[data-level=3]").data("select", null)
      $.ajax
        url: Store.context + "/api/admin/goods/look-toAddGdCat"
        type: "POST"
        data:
          id: id
        dataType: "JSON"
        success: (content)->
          result = liTemplate(content.data)
          $("ul[data-level=3]").empty()
          $("ul[data-level=3]").append(result)
    if currentLevel is 3
      $(".js-item-search-result").empty()
      that.goryId = id
      that.searchGoods()
  ## 商品列表检索
  goodsSearchItem: ->
    if($(this).val())
      $(@).closest(".search-item").next().find(".js-goods-info").hide().filter(":contains('" + ( $(this).val() ) + "')").show()
    else
      $(@).closest(".search-item").next().find(".js-goods-info").show()

## 置顶 商品
  createTopGoods: (evt)->
    evt.preventDefault()
    itemCode = ""
    goodsCode = ""
    $(".js-item-id").each ->
      if $(@).prop("checked") is true
        itemCode = $(@).val()
        goodsCode = $(@).data("goods")
    if itemCode == ""
      that.alert "body", "error", "", "请选择单品！"
      $(".alert").css("z-index": 9999)
    else
      $.ajax
        url: Store.context + "/api/admin/topGoods/updateStickOrder/#{itemCode}/create?stickOrder="
        type: "GET"
        success: (data)->
          if !data.data
            that.alert "body", "error", "新增失败", "置顶单品已存在！"
            $(".alert").css("z-index": 9999)
          else
            window.location.reload()

## 修改 置顶商品 顺序
  updateTopGoods: (evt) ->
    evt.preventDefault()
    $("form.topgoods-form-edit").validator
      isErrorOnParent: true
    itemCode = $("#goodsCode").data("item-code")
    stickOrder_new = $("[name=stickOrder]").val()
    stickorder_old = $("[name=stickOrder]").data("stickorder")
    if parseInt(stickOrder_new) is parseInt(stickorder_old)
      editModal.close()
      return
    $.ajax
      url: Store.context + "/api/admin/topGoods/updateStickOrder/#{itemCode}/edit?stickOrder=#{stickOrder_new}"
      type: "GET"
      success: (data)->
        if data.data is false
          that.alert "body", "error", "修改失败", "显示顺序已存在！"
          $(".alert").css("z-index": 9999)
        else
          window.location.reload()
# 删除
  deleteTopGoods: (evt, data)->
    itemCode = data
    $.ajax
      url: Store.context + "/api/admin/topGoods/updateStickOrder/#{itemCode}/delete?stickOrder="
      type: "GET"
      success: (data)->
        if data.data is false
          that.alert "body", "error", "删除失败", "删除失败！"
          $(".alert").css("z-index": 9999)
        else
          window.location.reload()

module.exports = TopGoods


