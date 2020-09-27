Modal = require "spirit/components/modal"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"

class giftRecommendation
  GIFT_RECOMMENDATION_DATA =
    'rangeDom': 0
    'regionId': 0
    'minPoint': ''
    'maxPoint': ''
    'goodsXid':''
    'goodsId':''
    'goodsNm':''
  constructor: ->
    @PointsRegionAdd = ".points-region-add"#新增积分区间
    @CancelAdd = ".btn-cancel-re"#取消按钮
    @CreatePointsGift = ".btn-insert-re" #新增按钮
    @bindEvent()
    @gift_recommendation_init()
  giftRecommendationTable = App.templates["gift_recommendation_table"]# 积分礼品推荐 tr

  that=this

  bindEvent: ->
    that = this
    $(document).on "click", ".add-property", @addPointsGift #新增礼品
    $(document).on "blur", ".gift-input", @inputGift
    $(@PointsRegionAdd).on "click", @addPointsRegion
    $(document).on "click", ".current-points-region", @currentPointsRegion #当前积分区间
    $(@CancelAdd).on "click",@cancelAdd
    $(@CreatePointsGift).on "click",@createPointsGift
    $(giftRecommendationTable).on "confirm:delete-gift",@deleteGift #删除礼品
    $(document).on "click", ".js-gift-hover-up", @giftUp #显示顺序上移
    $(document).on "click", ".js-gift-hover-down", @giftDown #显示顺序下移
    $(document).on "click", ".delete-region", @deleteRegion  #删除积分区间
    $(".gift-recommendation").on "click", ".js-goods-url", @hrefGoods



  #init 方法
  gift_recommendation_init: ->
    liDom = $('.admin-cat-box-list-points')
    if liDom.find('li').length > 0
      liDom.find('li:first').find('a:first').click()
    else
      TipAndAlert.alert "body", "error", "无初始化信息"

  #新增积分区间
  addPointsRegion: ->
    param = {}
    param.minPoint = $(".min-point").val()
    param.maxPoint = $(".max-point").val()
    if  param.minPoint is ""
      TipAndAlert.alert "body", "error", "最小积分值不得为空"
      return
    if param.maxPoint is ""
      TipAndAlert.alert "body", "error", "最大积分值不得为空"
      return
    if !that.isPositiveIntegers( param.minPoint)
      TipAndAlert.alert "body", "error", "最小积分值只能为整数"
      return
    if !that.isPositiveIntegers(param.maxPoint)
      TipAndAlert.alert "body", "error", "最大积分值只能为整数"
      return
    preMaxVal = $('.admin-cat-box-list-points').find('li:last').find('span:last').text()
    if preMaxVal isnt ""
      if parseInt( param.minPoint) < parseInt(preMaxVal)
        TipAndAlert.alert "body", "error", "最小积分值输入不正确"
        return
    if parseInt(param.maxPoint) <= parseInt(param.minPoint)
      TipAndAlert.alert "body", "error", "最大积分值输入不正确"
      return
    $.ajax
      url:  Store.context + "/api/admin/pointsGiftRecommendation/create"
      type: "POST"
      data: param
      success: (data)->
        window.location.reload()
      error: (data) ->
        new Modal(
          icon: "error"
          title: "出错啦！"
          content: data.responseText || "未知故障"
          overlay: false)
        .show()
  #新增礼品弹出
  addPointsGift: ->
    if GIFT_RECOMMENDATION_DATA.regionId != 0
      $.ajax
        url:  Store.context + "/api/admin/pointsGiftRecommendation/findPointsGiftCount"#判断此积分区间是否可以推荐礼品
        type: "GET"
        data: {
          'regionId': GIFT_RECOMMENDATION_DATA.regionId
        }
        success: (data)->
          if data.data
            $(".admin-add-property").show()
          else
            TipAndAlert.alert "body", "error", "此积分区间已有4条推荐信息，无法添加"
        error: (data) ->
          new Modal(
            icon: "error"
            title: "出错啦！"
            content: data.responseText || "未知故障"
            overlay: false)
          .show()
    else
      TipAndAlert.alert "body", "error", "请选择积分区间"

  #取消按钮
  cancelAdd : ->
    $('.admin-add-property').hide()
    $(".gift-input").val("")
    $(".giftName-input").val("")

  #当前积分区间
  currentPointsRegion :(event)->
    if GIFT_RECOMMENDATION_DATA.rangeDom != 0
      GIFT_RECOMMENDATION_DATA.rangeDom.removeClass('clickon')
    $(this).addClass('clickon')
    GIFT_RECOMMENDATION_DATA.rangeDom = $(this)

    regionId = $(@).closest("li").data("id")
    minPoint = $(@).closest("li").find("span:first").text()
    maxPoint = $(@).closest("li").find("span:last").text()
    goodsRecommendationJfModel = {}
    goodsRecommendationJfModel.regionId = regionId
    #把积分区间的放到全局变量中
    GIFT_RECOMMENDATION_DATA.regionId = regionId
    GIFT_RECOMMENDATION_DATA.minPoint = minPoint
    GIFT_RECOMMENDATION_DATA.maxPoint = maxPoint
    $.ajax
      url:  Store.context + "/api/admin/pointsGiftRecommendation/findRecommendGift"
      type: "GET"
      data: goodsRecommendationJfModel
      success: (data)->

        $('.points-gift-add').empty()
        attribute = giftRecommendationTable(data.data)
        $('.points-gift-add').append(attribute)

  #单品code输入框
  inputGift : ->
    goodsXid = $(".gift-input").val()
    GIFT_RECOMMENDATION_DATA.goodsXid = goodsXid
    if goodsXid != ""
      $.ajax
        url:  Store.context + "/api/admin/pointsGiftRecommendation/findGiftName"
        type: "GET"
        data: goodsXid :goodsXid
        success: (data)->
          $(".giftName-input").val(data.data.name)
          GIFT_RECOMMENDATION_DATA.goodsId = data.data.code #单品编码14位
          GIFT_RECOMMENDATION_DATA.goodsNm = data.data.name #单品名称
    else
      TipAndAlert.alert "body", "error", "请输入5位礼品编码"
  #保存按钮
  createPointsGift : ->
    if $('.giftName-input').val() != ''
      data = {}
      data.regionId = GIFT_RECOMMENDATION_DATA.regionId #积分区间ID
      data.minPoint = GIFT_RECOMMENDATION_DATA.minPoint #积分最小值
      data.maxPoint = GIFT_RECOMMENDATION_DATA.maxPoint #积分最大值
      data.goodsXid = GIFT_RECOMMENDATION_DATA.goodsXid #5位礼品编码
      $.ajax
        url:  Store.context + "/api/admin/pointsGiftRecommendation/findGiftInfCheck"
        type: "GET"
        data: data
        success: (data)->
            if data.data.giftCodeCheck #单品没有被推荐过
              if data.data.giftOnShelveCheck # 礼品已上架
                if data.data.giftPointsPriceCheck # 金普价在积分区间内
                  createData = {}
                  createData.regionId = GIFT_RECOMMENDATION_DATA.regionId #积分区间ID
                  createData.goodsNm = GIFT_RECOMMENDATION_DATA.goodsNm #礼品名称
                  createData.jpPoint = data.data.goodsPoint #金普价
                  createData.goodsXid = GIFT_RECOMMENDATION_DATA.goodsXid #5位礼品编码
                  createData.goodsId = GIFT_RECOMMENDATION_DATA.goodsId #14位单品编码
                  $.ajax
                    url:  Store.context + "/api/admin/pointsGiftRecommendation/createPointsGift"
                    type: "POST"
                    data: createData
                    success: (data)->
                          $(".admin-add-property").hide()
                          $(".gift-input").val("")
                          $(".giftName-input").val("")
                          GIFT_RECOMMENDATION_DATA.rangeDom.click()
                    error: (data) ->
                      new Modal(
                        icon: "error"
                        title: "出错啦！"
                        content: data.responseText || "未知故障"
                        overlay: false)
                      .show()
                else
                  TipAndAlert.alert "body", "error", "该礼品金普价不在此积分区间内"
                  return
              else
                TipAndAlert.alert "body", "error", "该礼品未上架不可推荐"
            else
              TipAndAlert.alert "body", "error", "该礼品在此积分区间已被推荐过"
    else
      TipAndAlert.alert "body", "error", "请输入正确的礼品编码"
  #判断是否为正整数
  isPositiveIntegers: (param)->
    return /^[0-9]\d*$/.test(param)

  #删除礼品
  deleteGift: (evt,id)->
#    id = $(@).closest("tr").data("id")
    id = id
    $.ajax
      url: Store.context + "/api/admin/pointsGiftRecommendation/"+id
      type: "POST"
      success: (data)->
        GIFT_RECOMMENDATION_DATA.rangeDom.click()

  #显示顺序上移
  giftUp: ->
    currentPosition = $(@).closest("tr")
    currentPositionId = $(@).closest("tr").data("id")
#    firstPosition = $(giftRecommendationTable).find("tr:first")
    prevPositionId = currentPosition.prev("tr").data("id")
#    firstPositionId = $(giftRecommendationTable).find("tr:first").data("id")
    if !prevPositionId
      TipAndAlert.alert "body", "error", "已置顶！"
      return
    prevPosition = currentPosition.prev()
    $.ajax
      url: Store.context + "/api/admin/pointsGiftRecommendation/changeSort"
      type: "POST"
      data: {
        currentId: currentPositionId
        currentSort : currentPosition.data("sort")
        changeId: prevPosition.data("id")
        changeSort : prevPosition.data("sort")
      }
      success: (data)->
        prevPosition.insertAfter(currentPosition)

  #显示顺序下移
  giftDown: ->
    currentPosition = $(@).closest("tr")
    nextPositionId = currentPosition.next("tr").data("id")
#    lastPosition = $("giftRecommendationTable").find("tr:last")
#    lastPositionId = $("giftRecommendationTable").find("tr:last").data("id").text()
    if !nextPositionId
      TipAndAlert.alert "body", "error", "已置底！"
      return
    nextPosition = currentPosition.next()
    $.ajax
      url: Store.context + "/api/admin/pointsGiftRecommendation/changeSort"
      type: "POST"
      data: {
        currentId: currentPosition.data("id")
        currentSort : currentPosition.data("sort")
        changeId: nextPosition.data("id")
        changeSort : nextPosition.data("sort")
      }
      success: (data)->
        currentPosition.insertAfter(nextPosition)

  #判断是否为空
  isNull: (param)->
    if param is ""
      TipAndAlert.alert "body", "error", "积分区间不得为空"

  #删除积分区间
  deleteRegion: ->
    regionIdStr = ''
    regionIdStr += $(this).closest('li').data('id') + ','
    $(this).closest('li').nextAll().each (index) ->
      regionIdStr += $(this).data('id') + ','
    $.ajax
      url: Store.context + "/api/admin/pointsGiftRecommendation/deletePointsRegion"
      type: "POST"
      data: {
          regionId : regionIdStr
      }
      success: (data)->
        window.location.reload()
      error: (data) ->
        new Modal(
          icon: "error"
          title: "出错啦！"
          content: data.responseText || "未知故障"
          overlay: false)
        .show()

  hrefGoods: ->
    goodsCode = $(@).data("goodscode")
    url = $(".js-main-title").data("main")
    window.location.href = "#{url}/mall/goods/#{goodsCode}"
module.exports = giftRecommendation