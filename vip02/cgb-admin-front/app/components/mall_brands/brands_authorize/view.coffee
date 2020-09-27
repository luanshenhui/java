Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
tipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"
brandViewTemp = App.templates["brands_authorize_view"]
class BrandsAuthorize
  _.extend @::, tipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  startMPicker = null
  endMPicker = null
  startPicker = null
  endPicker = null
  startAPicker = null
  endAPicker = null
  constructor: ->
    @$auditBrandBtn = $(".js-brand-audit")
    @$viewBrandBtn = $(".js-brand-view")
    @auditPassBtn = ".js-audit-pass"
    @auditRejectBtn =".js-audit-reject"
    @largeImg1 = ".brandImagebig"
    @largeImg2 = ".authorizeImagebig"
    @approveMemeo = ".js-approve-memeo"

    startMPicker = new Pikaday(
      field:  $(".js-date-startModify")[0]
      i18n: {
        previousMonth: "上月",
        nextMonth: "下月",
        months: [ "一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月" ],
        weekdays: [ "周日", "周一", "周二", "周三", "周四", "周五", "周六" ],
        weekdaysShort: [ "日", "一", "二", "三", "四", "五", "六" ]
      }
      onSelect: ->
        startDate = ($(".js-date-startModify").val()).replace(/-/g,"/")
        endMPicker.setMinDate(new Date(startDate))
    )
    endMPicker = new Pikaday(
      field: $(".js-date-endModify")[0]
      i18n: {
        previousMonth: "上月",
        nextMonth: "下月",
        months: [ "一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月" ],
        weekdays: [ "周日", "周一", "周二", "周三", "周四", "周五", "周六" ],
        weekdaysShort: [ "日", "一", "二", "三", "四", "五", "六" ]
      }
      onSelect: ->
        endDate = ($(".js-date-endModify").val()).replace(/-/g,"/")
        startMPicker.setMaxDate(new Date(endDate))
    )
    startPicker = new Pikaday(
      field:  $(".js-date-start")[0]
      i18n: {
        previousMonth: "上月",
        nextMonth: "下月",
        months: [ "一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月" ],
        weekdays: [ "周日", "周一", "周二", "周三", "周四", "周五", "周六" ],
        weekdaysShort: [ "日", "一", "二", "三", "四", "五", "六" ]
      }
      onSelect: ->
        startDate = ($(".js-date-start").val()).replace(/-/g,"/")
        endPicker.setMinDate(new Date(startDate))
    )
    endPicker = new Pikaday(
      field: $(".js-date-end")[0]
      i18n: {
        previousMonth: "上月",
        nextMonth: "下月",
        months: [ "一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月" ],
        weekdays: [ "周日", "周一", "周二", "周三", "周四", "周五", "周六" ],
        weekdaysShort: [ "日", "一", "二", "三", "四", "五", "六" ]
      }
      onSelect: ->
        endDate = ($(".js-date-end").val()).replace(/-/g,"/")
        startPicker.setMaxDate(new Date(endDate))
    )

    @bindEvent()
  that = this
  bindEvent:->
    that = this
    @$auditBrandBtn.on "click",@auditBrand
    @$viewBrandBtn.on "click",@viewBrand
    $(document).on "click",@auditPassBtn , @auditBrandConfirm
    $(document).on "click",@auditRejectBtn , @auditBrandConfirm
    $(document).on "click", @largeImg1, @largeimg1
    $(document).on "click", @largeImg2, @largeimg2
    $(document).on "keyup", @approveMemeo, @remainingText
    $(document).on "blur", @approveMemeo, @remainingText
    $("form.form-inline").on "submit", that.checkTime

  largeimg1:->
    html = '<div class="pop-up" style="display: block;" onclick="$(\'.pop-up\').remove()">'
    html = html + '<img width="600px" height="400px"class="img-center" src='
    html = html + ($(".brandImagebig").attr('src'))
    html = html + '></div>'
    $("body").append(html)

  largeimg2:->
    html = '<div class="pop-up" style="display: block;" onclick="$(\'.pop-up\').remove()"><div class="authorize-big">'
    html = html + '<img id="authorize-image-big"  src='
    html = html + ($(@).attr('src'))
    html = html + '></div></div>'
    $("body").append(html)
    left = $(window).width() / 2 - $("#authorize-image-big").width() / 2
    top = $(window).height() / 2 - $("#authorize-image-big").height() / 2
    $(".authorize-big").css("position","relative").css("left", left).css("top", top)


  viewBrand:->
    data = $(@).closest("tr").data("data")
    imgList=[]
    imgList.push(data.brandAuthorizeImage1)
    imgList.push(data.brandAuthorizeImage2)
    imgList.push(data.brandAuthorizeImage3)
    imgList.push(data.brandAuthorizeImage4)
    imgList.push(data.brandAuthorizeImage5)
    data.imgList = imgList
    new Modal(brandViewTemp({title: "查看品牌授权信息", data: data})).show()
    $(".js-img-li").css("margin-left","5px")

  auditBrand:(evt)->
    data = $(@).closest("tr").data("data")
    simpleName = data.simpleName
    type = "audit"
    imgList=[]
    imgList.push(data.brandAuthorizeImage1)
    imgList.push(data.brandAuthorizeImage2)
    imgList.push(data.brandAuthorizeImage3)
    imgList.push(data.brandAuthorizeImage4)
    imgList.push(data.brandAuthorizeImage5)
    data.imgList = imgList
    if data.approveDiff?
      data = JSON.parse(data.approveDiff)
      data.simpleName = simpleName
    new Modal(brandViewTemp({title: "审核品牌授权信息", data: data,type:type})).show()
    $(".js-img-li").css("margin-left","5px")

  auditBrandConfirm:(evt)->
    evt.preventDefault()
    approveState = "01"
    data =$(".brands-view-form").serializeObject()
    if $(@).data("type") is "reject"
      approveState = "02"
      if $(".js-approve-memeo").val() is ""
        that.alert "body","error","请填写审核意见"
        return
    data.approveState = approveState
    if $(".js-approve-memeo").val() isnt ""
      data.approveMemo = $(".js-approve-memeo").val()
    data.approveDiff = ""
    if approveState is "01"
      $.ajax
        url: Store.context + "/api/admin/brand/add-checkBrandName"
        type: "GET"
        data:
          brandName: data.brandName
        success: (datas)->
          if datas.data?
            if datas.data.brandInforStatus is "02"
              that.alert "body", "error", "品牌管理中存在被拒绝的品牌！"
              return
            else if datas.data.brandInforStatus is "00"
              that.alert "body", "error", "品牌管理中存在未审核的品牌！"
              return
            else
              $.ajax
                url: Store.context + "/api/admin/authorize/audit"
                type: "POST"
                data: data
                success: (data)->
                  if data.data == true || data.data == "true"
                    window.location.reload()
                  else
                    that.alert "body", "error", "审核失败请刷新页面重试"
          else
            $.ajax
              url: Store.context + "/api/admin/authorize/audit"
              type: "POST"
              data: data
              success: (data)->
                if data.data == true || data.data == "true"
                  window.location.reload()
                else
                  that.alert "body", "error", "审核失败请刷新页面重试"
    else
      $.ajax
        url: Store.context + "/api/admin/authorize/audit"
        type: "POST"
        data: data
        success: (data)->
          if data.data == true
            window.location.reload()
          else
            that.alert "body", "error", "审核失败请刷新页面重试"
# 时间录入合法性校验
  checkTime:()->
    a = $("#v_startModifyTime").val()
    b = $("#v_endModifyTime").val()
    c = $("#v_startTime").val()
    d = $("#v_endTime").val()
    if a isnt "" && b isnt ""
      a1 = new Date(a)
      b1 = new Date(b)
      if a1 > b1
        that.alert "body","error","申请时间:结束时间需大于开始时间"
        return false
    if c isnt "" && c isnt ""
      c1 = new Date(c)
      d1 = new Date(d)
      if c1 > d1
        that.alert "body","error","到期时间:结束时间需大于开始时间"
        return false

# textarea ie兼容问题
  remainingText: ->
    val = $("#descript").val()
    length = parseInt(val.length)
    text = 100 - length
    if length >= 100
      $(@).val(val.substr(0, 100))
      text = 0
    $(".remaining-text i").text(text)

module.exports = BrandsAuthorize