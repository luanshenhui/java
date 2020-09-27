Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"
tipAndAlert = require "tip_and_alert/tip_and_alert"

newGenerateGoodsSearch = App.templates.generate_goods_search #商品查询

newGenerateGoodsIds = App.templates.generate_goods_ids #生成商品编码
decorationGoodsDetail = App.templates.decoration_goods_detail #商品信息

class DecorationGoods
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  _.extend @::, tipAndAlert

  constructor: ->
    @select1 = ".js-select1" #后台类目一级
    @select2 = ".js-select2" #后台类目二级
    @select3 = ".js-select3" #后台类目三级
    @generateGoodsSearch = ".decoration-goods-search" #查询
    @generateGoodsIds = ".generate-goods-ids" #弹框 生成商品IDs
    @bindEvent()
    @categoryInit()
  that = this

  bindEvent: ->
    that = this
    $(document).on "change", @select1, @selectCategory
    $(document).on "change", @select2, @selectCategory
    $(document).on "click", @generateGoodsSearch, @generateGoodsSearchFunc
    $(document).on "click", @generateGoodsIds, @generateGoodsIdsFunc
    $(document).on "click",".decoration_goods_add", @addDecorationGoods
    $(document).on "click",".js-decoration-goods-delete", @deleteDecorationGoods

  categoryInit: ->
    id = 0
    #获取浏览器地址栏中相应字段的值
    backCategory1 = $.query.get('back_category1_id')
    backCategory2 = $.query.get('back_category2_id')
    backCategory3 = $.query.get('back_category3_id')
    $.ajax
      url: Store.context + "/api/admin/goods/look-toAddGdCat"
      type: "POST"
      data:
        id: id
      success: (result)->
        html = ''
        $.each(result.data, (index, item)->
          html += '<option  value=' + item.id + '>' + item.name + '</option>'
        )
        $('.js-select1').html('<option  value="">请选择</option>').append(html)
        $('.js-select1').val(backCategory1)
        if backCategory2 isnt true and backCategory2 isnt ""
          $.ajax
            url: Store.context + "/api/admin/goods/look-toAddGdCat"
            type: "POST"
            data:
              id: backCategory1
            success: (result)->
              html = ''
              $.each(result.data, (index, item)->
                html += '<option  value=' + item.id + '>' + item.name + '</option>'
              )
              $("select[data-level=2]").html('<option  value="">请选择</option>').append(html)
              $('.js-select2').val(backCategory2)
              if backCategory3 isnt true and backCategory3 isnt ""
                $.ajax
                  url: Store.context + "/api/admin/goods/look-toAddGdCat"
                  type: "POST"
                  data:
                    id: backCategory2
                  success: (result)->
                    html = ''
                    $.each(result.data, (index, item)->
                      html += '<option  value=' + item.id + '>' + item.name + '</option>'
                    )
                    $("select[data-level=3]").html('<option  value="">请选择</option>').append(html)
                    $('.js-select3').val(backCategory3)

#点击 后台类目联动
  selectCategory: ->
    id = $(@).val()
    level = $(@).data("level")
    nextLevel = level + 1
    #如果点击的是请选择，则return
    if id is ""
      $("select[data-level=" + nextLevel + "]").html('<option  value="">请选择</option>')
      if level is 1
        $("select[data-level=3]").html('<option  value="">请选择</option>')
      return
    $.ajax
      url: Store.context + "/api/admin/goods/look-toAddGdCat"
      type: "POST"
      data:
        id: id
      success: (result)->
        if level is 1
          $("select[data-level=3]").html('<option  value="">请选择</option>')
        html = ''
        $.each(result.data, (index, item)->
          html += '<option  value=' + item.id + '>' + item.name + '</option>'
        )
        $("select[data-level=" + nextLevel + "]").html('<option  value="">请选择</option>').append(html)

#装修选品  点击搜索按钮
  generateGoodsSearchFunc: ->
    tempData = []
    $.ajax
      url: Store.context + "/api/admin/goods/findItemListForDecoration"
      type: "POST"
      dataType: "json"
      data: {
        'backCategoryId': $(".js-select3").find("option:selected").val(),
        'goodsName': $(".decoration-goods-name").val()
      }
      success: (data)->
        tempData = data.data.result
        attribute = newGenerateGoodsSearch(tempData)
        $(".decoration-goods-search-show").empty()
        $(".decoration-goods-search-show").append(attribute)
        #将添加的商品增加按钮隐藏
        $(".decoration-goods-search-show").find("tr").each ->
          searchGoodsId = $.trim($(this).find("td:eq(0)").text())
          $(".decoration-goods-all").find("tr").each ->
            decorationGoodsId = $.trim($(this).find("td:eq(0)").text())
            $("#add-" + searchGoodsId).hide() if searchGoodsId==decorationGoodsId

  generateGoodsIdsFunc:->
    goodsIds = ''
    $(".decoration-goods-all").find("tr").each ->
      goodsId = $.trim($(this).find("td:eq(0)").text())
      goodsIds += goodsId + ','
    inputData = {}
    goodsIds= goodsIds.substr 0,goodsIds.length-1 if goodsIds.length>0
    inputData.goods = goodsIds
    new Modal(newGenerateGoodsIds(inputData)).show()
    $(".copy-goods-ids").on "click", ->
      copyGoodsIds = $("#goodsIds").val()
      window.clipboardData.setData 'TEXT',copyGoodsIds

  addDecorationGoods: (evt) ->
    data=$(evt.currentTarget).attr("id")
    goodsId = $("#tr-" + data).find("td:eq(0)").text()
    goodsNm = $("#tr-" + data).find("td:eq(1)").text()
    inputData = {}
    inputData.itemCode = goodsId
    inputData.goodsName = goodsNm
    appendGoods = decorationGoodsDetail(inputData)
    $(".decoration-goods-all").append(appendGoods)
    $("#" + data).hide()

  deleteDecorationGoods: (evt)->
    data=$(evt.currentTarget).attr("id")
    $("#" + data).parents("tr").remove()
    $("#add-" + data).show()

module.exports = DecorationGoods
