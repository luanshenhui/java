Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"

class activity_detail
  new Pagination(".pagination").total($(".pagination").data("total")).show()

  constructor: ->
    @activeDetailBack = ".active-detail-back" # 点击返回按钮
    @bindEvent()
    @detailInit()

  activityDetailFullDown = App.templates["activeity_detail_fullDown"] # 活动优惠规则  满减
  bindEvent: ->
  $(@activeDetailBack).on "click", @activeDetailBackFunc

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

    $('.vendor-name').text($('.vendor').html())

  #点击返回
  activeDetailBackFunc: ->
    window.location.href=Store.context + "/mall/activity/activity_all"


module.exports = activity_detail

