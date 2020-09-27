Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"
TipAndAlert = require "tip_and_alert/tip_and_alert"
class item_audit_detail
  new Pagination(".pagination").total($(".pagination").data("total")).show()

  that = this
  type = ''
  constructor: ->
    @passedButton = $('.passed')
    @refuseButton = $('.refuse')
    @remainingTarget = ".remaining-target"
    #绑定事件
    @bindEvent()
    @auditInit()

    type = $.query.get("type")
    if type == "audit"
      $('.passed').show()
      $('.refuse').show()
      $('.audit-div').show()
    else
      $('.passed').hide()
      $('.refuse').hide()
      $('.audit-div').hide()

  itemAuditFullDown = App.templates["item_audit_fullDown"]   # 活动优惠规则  满减


  #绑定事件
  bindEvent:->
    that = this
    @passedButton.on 'click', @passed
    @refuseButton.on 'click', @refuse
    $(document).on "keyup", @remainingTarget, @remainingText
    $(document).on "blur", @remainingTarget, @remainingText

  passed:(event)->
    event.preventDefault()
    refuseReason = $('.information-textarea').val()
    if refuseReason.length > 200
      TipAndAlert.alert "body", "error", "审核意见字数超出"
      return
    $.ajax
      url: Store.context + "/api/admin/promotion/checkStatus"
      type: "POST"
      data: {
        id: $('#hidden_id').val(),
        auditLog: $('.information-textarea').val(),
        checkStatus: 3
      }
      success: (data)->
#        window.history.back(-1)
#        self.location=document.referrer;
        window.location.href=Store.context + "/mall/activity/item-audit"

  refuse:(event)->
    event.preventDefault()
    refuseReason = $('.information-textarea').val()
    if refuseReason.length > 200
      TipAndAlert.alert "body", "error", "审核意见字数超出"
      return
    if refuseReason == ""
      TipAndAlert.alert "body", "error", "请输入审核内容"
      return
    else
      $.ajax
        url: Store.context + "/api/admin/promotion/checkStatus"
        type: "POST"
        data: {
          id: $('#hidden_id').val(),
          auditLog: refuseReason,
          checkStatus: 4
        }
        success: (data)->
#          self.location=document.referrer;
          window.location.href=Store.context + "/mall/activity/item-audit"

  auditInit: ->
    activeType = $('.active-type').data('value')
    if activeType is 20  #满减
      activeVal = $('.fullCut').data('value')
      fullVal = activeVal._DATA_.adminPromotionResultDto.ruleMinPays
      cutVal = activeVal._DATA_.adminPromotionResultDto.ruleFees
      if fullVal.length isnt 0 and cutVal.length isnt 0
        $.each(fullVal, (index, item)->
          $(".active-sale-rule").append(itemAuditFullDown)
          $(".active-sale-rule").find('.fullDown-add:last').find('input:first').val(fullVal[index])
          $(".active-sale-rule").find('.fullDown-add:last').find('input:last').val(cutVal[index])
        )

  remainingText: ->

    val = $("#descript").val()

    length = parseInt(val.length)

    text = 200 - length

    if length >= 200

      $(@).val(val.substr(0, 200))

      text = 0

    $(".remaining-text i").text(text)


module.exports = item_audit_detail

