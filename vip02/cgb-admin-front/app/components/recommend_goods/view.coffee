TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"
liTemplate = App.templates["recommend_back_category"]
recommendListGoodsTemplate = App.templates["recommend_list_goods"]

class recommendGoods
  _.extend @::, TipAndAlert

  constructor: ->
    @bindEvent()
  that = this

  bindEvent: ->
    that = this
    $(document).on "click", ".find-next-category", @findNextCategory
    $(document).on "click", ".add-property", @addProperty
    $(document).on "click", ".btn-insert-re", @btnInsertRe
    $(document).on "click", ".js-recommend-goods-down", @recommendGoodsDown
    $(document).on "click", ".js-recommend-goods-up", @recommendGoodsUp
    $(document).on "blur", ".goodsMid-input", @inputGoods
    $(document).on "mouseover mouseout", ".list-goods-mouse", @mouseOverAndOut
    $(document).on "confirm:delete-recommend", @deleteRecommend
    $(".recommend-goods").on "click", ".js-goods-url", @hrefGoods

  mouseOverAndOut: (event) ->
    if(event.type is "mouseover")
      $(@).find(".hover-box").show()
    if (event.type == "mouseout")
      $(@).find(".hover-box").hide()

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
    nextLevel = currentLevel + 1
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
    #    ###清空节点并显示###
    if currentLevel is 3
      params = {}
      level1 = $("#level1 .clickon").parent("li").data('id')
      level2 = $("#level2 .clickon").parent("li").data('id')
      level3 = $("#level3 .clickon").parent("li").data('id')

      params.name = ''
      params.backCategory1Id = level1
      params.backCategory2Id = level2
      params.backCategory3Id = level3
      params.backgoryId = level3

      $.ajax
        url: Store.context + "/api/admin/recommendation/recommendation"
        type: "POST"
        data: params
        dataType: "JSON"
        success: (content)->
          result = recommendListGoodsTemplate({data: content.data})
          $("div[data-level=4]").empty()
          $("div[data-level=4]").append(result)
        error: (e)->
          $("div[data-level=4]").empty()
    else
      $("div[data-level=4]").empty()



#新增弹框
  addProperty: ->
    if $(".recommend-goods .admin-add-property").css("display") is "none"
      $(".recommend-goods .admin-add-property").show()
    else
      $(".recommend-goods .admin-add-property").hide()
      $(".goodsMid-input").val("")
      $(".goodsName-input").val("")

  inputGoods: ->
    goodsMid = $(".goodsMid-input").val()
    if goodsMid == ""
      that.alert "body", "error", "请输入商品编码"
      return
    else
      $.ajax
        url: Store.context + "/api/admin/recommendation/findItemInfoByItemCode"
        type: "POST"
        data:
          "goodsMid": goodsMid
        success: (data)->
          if data.data
            $(".goodsName-input").val(data.data.name)
            $(".js-goodsCode").val(data.data.code)
            $(".js-itemCode").val(data.data.itemCode)

#新增
  btnInsertRe: ->
    params = {}
    level1 = $("#level1 .clickon").parent("li").data('id')
    level2 = $("#level2 .clickon").parent("li").data('id')
    level3 = $("#level3 .clickon").parent("li").data('id')

    goodsMid = $(".goodsMid-input").val() ## 单品 ID
    itemCode = $(".js-itemCode").val() ## 单品 ID
    goodsCode = $(".js-goodsCode").val() ## 商品 ID
    goodsName = $(".goodsName-input").val() ## 商品名称

    if goodsMid is ""
      that.alert "body", "error", "请输入商品编码"
      return
    params.backCategory1Id = level1
    params.backCategory2Id = level2
    params.backCategory3Id = level3
    params.itemCode = itemCode
    params.code = goodsCode
    params.mid = goodsMid
    params.name = ''
    params.backgoryId = level3

    $.ajax
      url: Store.context + "/api/admin/recommendation/checkgoodscode"
      type: "POST"
      data: params
      dataType: "JSON"
      success: (data)->
        if data.data is true
          typePid = $("#level3 .clickon").parent("li").data('id')
          ## 准备数据
          params.typePid = typePid
          params.goodsId = itemCode
          params.goodsNm = goodsName
          params.goodsMid = goodsMid
          $.ajax
            url: Store.context + "/api/admin/recommendation/insertGoodsRecommendation"
            type: "POST"
            data: params
            success: (data)->
              if data.data.successFlag = 1
                that.alert "body", "success", "保存成功！"

                params.goodsSeq = data.data.goodsSeqMax
                result = recommendListGoodsTemplate([params])
                $("div[data-level=4]").append(result)

                ## 隐藏 显示出样式
                that.addProperty()
              else
                that.alert "body", "success", "保存失败！"

#删除
  deleteRecommend: (event, data) ->
    event.preventDefault()
    goodsId = data
    $.ajax
      url: Store.context + "/api/admin/recommendation/delete/#{goodsId}"
      type: "POST"
      success: (data)->
        $(".list-goods-mouse[data-id=" + goodsId + "]").remove()

  recommendGoodsDown: (event)->
    currentNode = $(@).closest(".list-goods-mouse")
    lastNode = $(".recommend-list-goods").find(".list-goods-mouse:last")
    if currentNode.is(lastNode)
      that.alert "body", "error", "移动失败", "当前节点已经是最后一个了"
      return
    nextNode = currentNode.next()
    $.ajax
      url: Store.context + "/api/admin/recommendation/changeSort"
      type: "POST"
      data: {
        currentId: currentNode.data("id")
        currentDelFlag: currentNode.data("delflag")
        changeId: nextNode.data("id")
        changeDelFlag: nextNode.data("delflag")
      }
      success: (data)->
        currentNode.insertAfter(nextNode)


  recommendGoodsUp: (event)->
    currentNode = $(@).closest(".list-goods-mouse")
    firstNode = $(".recommend-list-goods").find("div:first")
    if currentNode.is(firstNode)
      that.alert "body", "error", "移动失败", "当前节点已经是第一个"
      return
    prevNode = currentNode.prev()
    $.ajax
      url: Store.context + "/api/admin/recommendation/changeSort"
      type: "POST"
      data: {
        currentId: currentNode.data("id")
        currentDelFlag: currentNode.data("delflag")
        changeId: prevNode.data("id")
        changeDelFlag: prevNode.data("delflag")
      }
      success: (data)->
        prevNode.insertAfter(currentNode)

  hrefGoods: ->
    goodsCode = $(@).data("goodscode")
    url = $(".js-main-title").data("main")
    window.location.href = "#{url}/mall/goods/#{goodsCode}"

  module.exports = recommendGoods
