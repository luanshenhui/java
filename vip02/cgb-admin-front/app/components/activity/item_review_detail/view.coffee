Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"
TipAndAlert = require "tip_and_alert/tip_and_alert"

class itemReviewDetail
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  refusedModalTemplate = App.templates["refusedModal"]
  activityDetailFullDown = App.templates["activity_detail_fullDown"] # 活动优惠规则  满减
  that = this
  type = ""
  isJoined = ""
#  itemPageNo = 1
#  itemPageSize = 2
  itemCode = ""
  refusedModal = null
  constructor: ->
    @itemPassedButton = $('.item-passed')
    @itemRefusedButton = $('.item-refused')
    @itemSearchButton = $('.item-search')
    @activityPassedButton = $('.activity-passed')
    @activityRefuseButton = $('.activity-refused')
    @remainingTarget = ".remaining-target"

    #绑定事件
    @bindEvent()
    @detailInit()
    type = $.query.get("type")
    if type == "review"
      isJoined = $.query.get("isJoined")
      $('.checkState-head').hide()
      $('.checkState-body').hide()
      if isJoined == "0"
        $('.review-textarea').show()
        $('.activity-passed').show()
        $('.activity-refuse').show()
        $('.check-status-select').hide()
        $('.check-status-td').hide()
        $('.check-status-td-value').hide()
        $('.option-td').hide()
        $('.option-td-value').hide()
      else
        $('.review-textarea').hide()
        $('.passed').hide()
        $('.refuse').hide()
        $('.check-status-select').show()
        $('.check-status-td').show()
        $('.check-status-td-value').show()
        $('.option-td').show()
        $('.option-td-value').show()
    else
      $('.review-textarea').hide()
      $('.passed').hide()
      $('.refuse').hide()
      $('.option-td').hide()
      $('.option-td-value').hide()

  #绑定事件
  bindEvent:->
    that = this
    @itemRefusedButton.on "click", @itemRefused
    @itemPassedButton.on "click", @itemPassed
    @itemSearchButton.on "click", @itemSearch
    @activityPassedButton.on "click", @activityPassed
    @activityRefuseButton.on "click", @activityRefused
    $(document).on "keyup", @remainingTarget, @remainingText
    $(document).on "blur", @remainingTarget, @remainingText

  detailInit: ->
    if $('.active-type').data('value') is '满减'
      allData = $('.full-cut').data('value')
      fullVal = allData._DATA_.adminPromotionResultDto.ruleMinPays
      cutVal = allData._DATA_.adminPromotionResultDto.ruleFees
      if fullVal.length isnt 0 and cutVal.length isnt 0
        $.each(fullVal, (index, item)->

          $(".full-cut").append(activityDetailFullDown)
          $(".full-cut").find('.fullDown-add:last').find('input:first').val(fullVal[index])
          $(".full-cut").find('.fullDown-add:last').find('input:last').val(cutVal[index])
        )

    $('.vendorName').html($('.prom-item-dtos').children('tr:first').data("data").vendor)

  # 折扣 满减  单品点击 通过
  itemPassed:(event)->
    event.preventDefault()

    id = $(this).parent('.option-td-value').attr('data-id')
    auditLog = $(this).parent('.option-td-value').attr('data-auditLog')
    promotionId = $('#hidden_id').val()
    itemId = $(@).closest("tr").find(".itemCodeTd").data("id")
    $.ajax
      url: Store.context + "/api/admin/promotion/audit-doubleCheckItem"
      type: "POST"
      data: {
        id: id,
        promotionId: promotionId,
        auditLog: auditLog,
        checkStatus: 1,
        itemId:itemId
      }
      success: (data)->

        $('[data-id="item-check-status-'+id+'"]').html("已通过")
        $('[data-id="'+id+'"]').html("")



  itemRefused:(event)->
    event.preventDefault()
    refuseMsg = $('.activity-textarea').val()

    itemCode = $(this).parent('.option-td-value').attr('data-id')
    auditLog = $(this).parent('.option-td-value').attr('data-auditLog')
    promotionId = $('#hidden_id').val()

    refusedModal = new Modal refusedModalTemplate({title:"审核意见", id:itemCode, promotionId:promotionId, auditLog:auditLog})
    refusedModal.show()
    $("form.review-form").validator isErrorOnParent: true
    $(document).on "submit", that.reviewRefused

  reviewRefused:(event) ->
    event.preventDefault()
    refuseMsg = $('#auditLog').val()
    if refuseMsg == ""
      alert "请输入审核内容"
      return
    $("form.review-form").validator isErrorOnParent: true
    $.ajax
      url: Store.context + "/api/admin/promotion/audit-doubleCheckItem"
      type: "POST"
      data: $("form.review-form").serialize()
      success: (data)->
        refusedModal.close()
        $('[data-id="item-check-status-'+itemCode+'"]').html("已拒绝")
        $('[data-id="'+itemCode+'"]').html("")

  itemSearch:->

    $.ajax
      url: Store.context + "/api/admin/promotion/findRanges"
      type: "POST"
      data: {
        promotionId: $('#hidden_id').val(),
        itemName: $('.item-name').val(),
        checkStatus: $('.item-check-status').val(),
        vendorName: $('.item-vendor-name').val()
#        size: 2,
#        pageNo: 1
      }
      success: (data)->
        ###获取活动类型###
        promType=$(".js-prom-type").data("data")
        createOperType=$(".createOperType").data("createoper")
        $('.prom-item-dtos').html('')
        items = data.data.data
        if items
          for item, i in items
            costByName = data.data.data[i].costBy
            if costByName == '1'
              costByName = '供应商'
            else
              costByName = '行方'
            checkStatusName = ""
            if item.checkStatus == "0"
              checkStatusName = "待审核"
            else if item.checkStatus == "1"
              checkStatusName = "已通过"
            else if item.checkStatus == "2"
              checkStatusName = "已拒绝"
            backCategoryName = ""
            if item.backCategoryName == null
              backCategoryName = item.backCategory1Name + '>'+item.backCategory2Name+'>'+item.backCategory3Name
            else
              backCategoryName = item.backCategoryName
            couponEnableName=""
            if item.couponEnable+"" is "1"
              couponEnableName="是"
            else
              couponEnableName="否"
            html = '<tr>'+
                      '<td>'+item.id+'</td>'+
                      '<td>'+backCategoryName+'</td>'+
                      '<td>'+item.goodsBrandName+'</td>'+
                      '<td>'+item.itemCode+'</td>'+
                      '<td>'+item.goodsName+'</td>'+
                      '<td>'+item.vendor+'</td>'
            if _.isEqual(promType,40)
              html+= '<td>'+item.levelPrice+'</td>'+
                     '<td>'+item.perStock+'</td>'+
                     '<td>'+costByName+'</td>'+
                     '<td>'+item.groupClassifyName+'</td>'
            else if _.isEqual(promType,50)
              html+=  '<td>'+item.startPrice+'</td>'+
                      '<td>'+item.minPrice+'</td>'+
                      '<td>'+item.feeRange+'</td>'+
                      '<td>'+item.perStock+'</td>'+
                      '<td>'+costByName+'</td>'
            else if _.isEqual(promType,30)
              html+=  '<td>'+item.price+'</td>'+
                  '<td>'+item.perStock+'</td>'+
                  '<td>'+costByName+'</td>'+
                  '<td>'+couponEnableName+'</td>'
            else
              html+=  '<td>'+item.price+'</td>'+
                      '<td>'+item.perStock+'</td>'+
                      '<td>'+costByName+'</td>'

            if type == "review" && isJoined == 1

              html += '<td >'+checkStatusName+'</td>'+
                '<td class="option-td-value" data-id='+
                  item.id +
                  'data-auditLog=' +
                  item.auditLog +
                  '>'
              if item.checkStatus is "0"
                  html+='<a href="#" class="margin-right-10 item-passed">通过</a>' +
                         '<a href="#" class="item-refused">拒绝</a></td>' +
                        '</tr>'
            if (type=="detail" and createOperType is 0) and (promType is 10 or promType is 20)
              html+="<td>"+checkStatusName+"</td>"
            # data-id="'+item.id+'" data-auditLog="'+item.auditLog+'"
            $('.prom-item-dtos').append(html)


  #秒杀 团购 荷兰拍 复审通过
  activityPassed:->
    singleItemData = []
    tr = $('.list-tabble-con').find('tr')
    if tr.length != 0
      tr.each (index) ->
        if index > 0
          dataTemp = {}
          dataTemp.promId = $('#hidden_id').val()
          dataTemp.goodsId = $(this).find('td').eq(3).text()
          dataTemp.promType = $('.active-type').data('data')
          dataTemp.goodsPrice = $(this).find('td').eq(6).text()
          singleItemData.push(dataTemp)
    else
      TipAndAlert.alert "body", "error", "复审商品不存在"
      return

    textArea = $('.activity-textarea').val();
    if textArea.length > 200
      TipAndAlert.alert "body", "error", "审核意见字数超出200"
      return
    $.ajax
      url: Store.context + "/api/admin/promotion/audit-doubleCheckPromotion"
      type: "POST"
      data: {
        reviewRange: JSON.stringify(singleItemData),
        promotionId: $('#hidden_id').val(),
        auditLog: $('.activity-textarea').val(),
        checkStatus: 7,
        rate: $('.discountRateSpan').text()
      }
      success: (data)->
        window.location.href=Store.context + "/mall/activity/item-review"

  activityRefused:->
    refuseMsg = $('.activity-textarea').val()
    if refuseMsg == ""
      TipAndAlert.alert "body", "error", "请输入审核内容"
      return
    if refuseMsg.length > 200
      alert "审核意见字数超出200"
      return
    $.ajax
      url: Store.context + "/api/admin/promotion/audit-doubleCheckPromotion"
      type: "POST"
      data: {
        promotionId: $('#hidden_id').val(),
        auditLog: $('.activity-textarea').val(),
        checkStatus: 6
      }
      success: (data)->
        window.location.href=Store.context + "/mall/activity/item-review"

  remainingText: ->

    val = $("#descript").val()

    length = parseInt(val.length)

    text = 200 - length

    if length >= 200

      $(@).val(val.substr(0, 200))

      text = 0

    $(".remaining-text i").text(text)

module.exports = itemReviewDetail

