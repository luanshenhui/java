Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"

newSupplierAdd = App.templates["supplierAdd"]
newActivityGoodsAdd = App.templates["activityGoodsAdd"]
newActivityGoodsAddSearch = App.templates["activityGoodsAdd_search"]

class activity_edit
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  activity_add_ids = ''
  activity_add_loop_season = 0          #循环场次总数
  startEntry = null
  endEntry = null
  start = null
  end = null

  constructor: ->
    require.async(['/static/umeditor/umeditor.config.js', '/static/umeditor/umeditor.min.js'], (a)->
      um = UM.getEditor('myEditor', {
        toolbar:[
          'undo redo | bold italic underline strikethrough | superscript subscript | forecolor backcolor | removeformat |',
          'insertorderedlist insertunorderedlist | selectall cleardoc paragraph | fontfamily fontsize' ,
          '| justifyleft justifycenter justifyright justifyjustify |',
          '| horizontal', 'formula'
        ]
        zIndex: 99
      });
      um.addListener "ready", ->
        um.setContent($('.active-Context').data('value'))
    )
#    @$el.find(".datepicker").datepicker()
    @activityCreate = ".js-activity-create"
    @fullDownDel = ".fullDown-del-btn"
    @activityRangeDel = ".js-content-delete" #活动范围 删除 按钮 ， 秒杀
    @activetyRangeGroupDel = ".act-range-groupby-delete" #活动范围 团购 table 删除按钮
    @activityRangeAddDiscount = ".range-add-btn" #活动范围  折扣和满减  添加按钮
    @discountFulldownSupplierWinOK = ".discount-fulldown-supplier-ok" #活动范围  折扣满减  选择供应商  弹窗 点击确定
    @newActiveSave = ".new-active-save" #新建活动  点击 保存
    @newActiveSubmitAudit = ".new-active-submit-auditing"  #新建活动  点击 提交审核

    @select1 = ".js-select1" #后台类目一级
    @select2 = ".js-select2" #后台类目二级
    @select3 = ".js-select3" #后台类目三级

    @addGoodsConfirm = ".addGoodsConfirm" #秒杀 团购 荷兰拍 活动优惠规则 新增弹窗 点击确定
    @activityLoop = ".recycleActivity" #活动基本条件  是否循环执行 checkbox
    @dayRadio = ".byDay" #循环执行 每日 radiobutton
    @weekRadio = ".byWeek" #循环执行 每周 radiobutton
    @monthRadio = ".byMonth" #循环执行 每月 radiobutton
    @formActiveSuccess = "form.product-add-form"

    @beginDate = ".beginDate" # 活动开始时间
    @endDate = ".endDate" # 活动结束时间
    @btnCancle = ".button-cancle"  #取消按钮
    @addGoodsSearch = ".add-goods-search" #活动范围 弹窗 查询

    startEntry = {
      elem: '#js-date-startEntry',
      format:  'YYYY-MM-DD hh:mm:ss', #自动生成的时间格式
      istime: true, #必须填入时间
    }
    endEntry = {
      elem: '#js-date-endEntry',
      format:  'YYYY-MM-DD hh:mm:ss', #自动生成的时间格式
      istime: true, #必须填入时间
    }
    laydate(startEntry)
    laydate(endEntry)

    start = {
      elem: '#js-date-start',
      format:  'YYYY-MM-DD hh:mm:ss', #自动生成的时间格式
      istime: true, #必须填入时间

    }
    end = {
      elem: '#js-date-end',
      format:  'YYYY-MM-DD hh:mm:ss', #自动生成的时间格式
      istime: true, #必须填入时间
    }
    laydate(start)
    laydate(end)

    @bindEvent()
    @editInit()

  newActiveSalePriceDiscount = App.templates["active_sale_rule_discount"] # 活动优惠规则   折扣
  newActiveSaleRuleFullDown = App.templates["active_sale_rule_fullDown"] # 活动优惠规则  满减
  newActiveSaleRuleSecond = App.templates["active_sale_rule_second"] # 活动优惠规则  秒杀
  newActiveSaleRuleGroupBy = App.templates["active_sale_rule_groupBy"] # 活动优惠规则  团购
  newActiveSaleRuleSale = App.templates["active_sale_rule_sale"] # 活动优惠规则  秒杀

  newActiveRangeDiscount = App.templates["activity_range_discount"] #活动范围 折扣
  newActiveRangeFullDown = App.templates["activity_range_fullDown"] #活动范围 满减
  newActiveRangeSecond = App.templates["activity_range_second"] #活动范围 秒杀 tbody
  newActivityRangeSecondThead = App.templates["activity_range_second_thead"] #活动范围 秒杀 thead
  newActiveRangeGroupBy = App.templates["activity_range_groupBy"] #活动范围 团购 tbody
  newActiveRangeGroupByThead = App.templates["activity_range_groupBy_thead"] #活动范围 团购 thead
  newActiveRangeSale = App.templates["activity_range_sale"] #活动范围 荷兰拍 tbody
  newActiveRangeSaleThead = App.templates["activity_range_sale_thead"] #活动范围 荷兰拍 thead

  newDayWeekMonth = App.templates["day_week_month"] # 是否循环执行  每日 每周 每月  radio button
  newByWeek = App.templates["every_week"] #循环执行  周一到周末
  newByMonth = App.templates["every_month"] #循环执行  1号到31号
  newLoopTime = App.templates["loop_time"] #循环执行  场次信息
  activityAlertMsg = App.templates["active_alert_msg"]

  that = this
  checkFlag = null

  bindEvent: ->
    that = this
    $(".activitys-add").on "click", @activityCreate, @newActivity
    $("#ForType").on "change", @discountOff
    $(".js—add—content").on "click", @addActiveGoods
    $(document).on "click", (@activityRangeDel), @deleteActivityRangeTable
    $(document).on "click", (@activetyRangeGroupDel), @activeRangeGroupbyDel
    $(".fullDown-add-btn").on "click", @addFullDowmRole
    $(document).on "change", @select1, @selectCategory
    $(document).on "change", @select2, @selectCategory
    $(document).on "click", (@fullDownDel), @delFullDowmRole
    $(@activityLoop).on "click", @activityLoopFunc
    $(document).on "click", (@addGoodsConfirm), @addGoodsConfirmFunc
    $(document).on "click", (@dayRadio), @dayRadioOnclick
    $(document).on "click", (@weekRadio), @weekRadioOnclick
    $(document).on "click", (@monthRadio), @monthRadioOnclick
    $(document).on "click", (@activityRangeAddDiscount), @activityRangeAddDiscountFunc
    $(@newActiveSave).on "click", @activeSaveClick
    $(@newActiveSubmitAudit).on "click", @activeSubmitAudit
    $(document).on "click", (@discountFulldownSupplierWinOK), @discountFulldownSupplierWinOKFunc
    $(document).on "click", (".activeRange-discount-del"), @activeRangeDiscountDel
    $(document).on "click", (".activeRange-FullDown-del"), @activeRangeFullDownDel
#    $("form.newActivity-add-form").validator
#      isErrorOnParent: true
    $("form.newActivity-add-form").on "submit", that.activeSaveClick
    $(@beginDate).on "blur", @changeActiveDate
    $(@endDate).on "blur", @changeActiveDate
    $(@btnCancle).on "click", @buttonCancle
    $(document).on "click", (@addGoodsSearch), @addGoodsSearchFunc
    $(document).on "click", ('.range-model-cancel'), @rangeModelCancel


  #活动类型 初始化
  editInit: ->
    #下拉框初始化
    selectVal = $('#ForType').data("value")
    if selectVal is "折扣"
      $('#ForType').val(10)
      $('.active-singup-time').show()
    else if selectVal is "满减"
      $('#ForType').val(20)
      $('.active-singup-time').show()
    else if selectVal is "秒杀"
      $('#ForType').val(30)
      $('.active-singup-time').hide()
    else if selectVal is "团购"
      $('#ForType').val(40)
      $('.active-singup-time').hide()
    else if selectVal is "荷兰拍"
      $('#ForType').val(50)
      $('.active-singup-time').hide()
    that.discountOff()

    #销售渠道初始化
    saleChannelarr = []
    saleChannelarr =  $('.sale-channel').data("value").split(",")
    $.each(saleChannelarr, (index, item)->
      if item is '商城'
        $(".channel-check1").prop("checked",'checked')
      else if item is 'CC'
        $(".channel-check2").prop("checked",'checked')
      else if item is 'IVR'
        $(".channel-check3").prop("checked",'checked')
      else if item is '手机商城'
        $(".channel-check4").prop("checked",'checked')
      else if item is '短信'
        $(".channel-check5").prop("checked",'checked')
      else if item is '微信广发银行'
        $(".channel-check6").prop("checked",'checked')
      else if item is '微信广发信用卡'
        $(".channel-check7").prop("checked",'checked')
      else if item is 'APP'
        $(".channel-check10").prop("checked",'checked')
    )

    #循环执行初始化
    dayWeekMonth = $('.recycleActivity').data("value")
    if dayWeekMonth isnt ''
      #循环执行 checkbox 勾选
      $('.recycleActivity').prop("checked",'checked')
      that.activityLoopFunc()

      if dayWeekMonth is 'd' #按照天循环
        $('.byDay').attr("checked","checked")
        that.dayRadioOnclick()
      else if dayWeekMonth is 'w' #按照周循环
        $('.byWeek').attr("checked","checked")
        that.weekRadioOnclick()
        #周一到周日 checkbox
        loopData = $('.recycleActivity').data("data")
        loopDataArr = []
        loopDataArr = loopData.split(',')
        loopDataArr.pop() #因为最后一个是空值 所以要pop出去
        #勾选星期
        $.each(loopDataArr, (index, item)->
          $(".weekCk").eq(item-1).prop("checked",'checked')
        )
      else if dayWeekMonth is 'm' #按月循环
        $('.byMonth').attr("checked","checked")
        that.monthRadioOnclick()
        loopData = $('.recycleActivity').data("data")
        loopDataArr = []
        loopDataArr = loopData.split(',')
        loopDataArr.pop() #因为最后一个是空值 所以要pop出去
        #勾选day
        $.each(loopDataArr, (index, item)->
          $(".day" + item).prop("checked",'checked')
        )
      #循环时间场次
      #时间 场次1 存在 活动报名时间 开始 结束时间 data-value中
      beginEntryTemp1 = $('.beginEntryDate').data('value')
      endEntryTemp1 = $('.endEntryDate').data('value')

      if beginEntryTemp1 != '' && endEntryTemp1 != ''
        beginEntryTemp = beginEntryTemp1.split(' ')[3]
        endEntryTemp = endEntryTemp1.split(' ')[3]

        beginEntryHH1 = beginEntryTemp.split(':')[0]
        beginEntryMM1 = beginEntryTemp.split(':')[1]
        beginEndHH1 = endEntryTemp.split(':')[0]
        beginEndMM1 = endEntryTemp.split(':')[1]

        $('.loopBeginTimeHH1').val(beginEntryHH1)
        $('.loopBeginTimeMM1').val(beginEntryMM1)
        $('.loopEndTimeHH1').val(beginEndHH1)
        $('.loopEndTimeMM1').val(beginEndMM1)

      #时间 场次2 存在 活动时间 开始 结束时间 data-value 中
      beginEntry2Temp = $('.beginDate').data('value')
      endEntry2Temp = $('.endDate').data('value')
      if beginEntry2Temp != '' && endEntry2Temp != ''
        beginEntry2TempArr = beginEntry2Temp.split(' ')[3]
        endEntry2TempArr = endEntry2Temp.split(' ')[3]

        beginEntry2HH1 = beginEntry2TempArr.split(':')[0]
        beginEntry2MM1 = beginEntry2TempArr.split(':')[1]
        endEntry2HH1 = endEntry2TempArr.split(':')[0]
        endEntry2MM1 = endEntry2TempArr.split(':')[1]

        $('.loopBeginTimeHH2').val(beginEntry2HH1)
        $('.loopBeginTimeMM2').val(beginEntry2MM1)
        $('.loopEndTimeHH2').val(endEntry2HH1)
        $('.loopEndTimeMM2').val(endEntry2MM1)

    #活动优惠规则 数据保存在 title 的 data-value 中
    if selectVal is '折扣'
      temp = $('.active-rule-title').data("value")

      if temp isnt ''
        tempArr = temp.split(',')
        $('.ruleDiscountRate').val(tempArr[0]) #折扣比例
        $('.ruleLimitBuyCount').val(tempArr[1]) #限购数量
        #限购数量种类  0 单日内限购，1 整个活动限购
        if tempArr[2] is '0'
          $('.limitRadioDay').attr("checked","checked")
        else
          $('.limitRadioActive').attr("checked","checked")
    else if selectVal is '满减'
      fullTemp = $('.active-rule-title').data("value")
      cutTemp = $('.active-rule-title').data("title")

      if fullTemp.length isnt 0
        $.each(fullTemp, (index, item)->

          if index is 0    #满减  页面默认存在一行
            $(".active-sale-rule").find('.fullDown-add:first').find('input:first').val(fullTemp[index])
            $(".active-sale-rule").find('.fullDown-add:first').find('input:last').val(cutTemp[index])
          else
            $(".active-sale-rule").append(newActiveSaleRuleFullDown)
            $(".active-sale-rule").find('.fullDown-add:last').find('input:first').val(fullTemp[index])
            $(".active-sale-rule").find('.fullDown-add:last').find('input:last').val(cutTemp[index])
      )
    else if selectVal is '秒杀'
      secondTemp = $('.active-rule-title').data('value')
      if secondTemp isnt ''
        secondTempArr = secondTemp.split(',')
        #限购数量
        $('.ruleLimitBuyCount').val(secondTempArr[0])
        #限购数量种类
        if secondTempArr[1] is '0'
          $('.limitRadioDay').attr("checked","checked")
        else
          $('.limitRadioActive').attr("checked","checked")
    else if selectVal is '团购'
      groupbyTemp = $('.active-rule-title').data('value')
      if groupbyTemp isnt ''
        groupbyTempArr = groupbyTemp.split(',')
        $('.ruleLimitBuyCount').val(groupbyTempArr[0])
        if groupbyTempArr[1] is '0'
          $('.limitRadioDay').attr("checked","checked")
        else
        $('.limitRadioActive').attr("checked","checked")
    else if selectVal is '荷兰拍'
      saleTemp = $('.active-rule-title').data('value')
      if saleTemp isnt ''
        saleTempArr = saleTemp.split(',')
        $('.ruleFrequency').val(saleTempArr[0])
        $('.ruleLimitBuyCount').val(saleTempArr[1])
        $('.ruleLimitTicket').val(saleTempArr[2])
        $('.ruleGroupCount').val(saleTempArr[3])
        if saleTempArr[4] is '0'
          $('.limitRadioDay').attr("checked","checked")
        else
          $('.limitRadioAvtive').attr("checked","checked")
    that.activeRangeInit()

  #活动范围  初始化
  activeRangeInit: ->
    selectVal = $('#ForType').data("value")
    if selectVal is '荷兰拍' or selectVal is '团购' or selectVal is '秒杀'
      activeRangeSaleTemp = $('.active-range-title').data('data')
      activeRangeList = activeRangeSaleTemp._DATA_.promItemDtos
      dataList = []
      count = 0

      if activeRangeList isnt undefined
        $.each(activeRangeList, (index, item)->
          dataTemp =
            'index': ++count
            'itemCode': activeRangeList[index].itemCode                     #单品编码
            'backCategory': activeRangeList[index].backCategory             #后台类目id
            'backCategoryName': activeRangeList[index].backCategory1Name + '>' + activeRangeList[index].backCategory2Name + '>' + activeRangeList[index].backCategory3Name
            'goodsName': activeRangeList[index].goodsName                  #商品名称
            'goodsBrandName': activeRangeList[index].goodsBrandName      #品牌名称
            'venderName': activeRangeList[index].vendor                     #供应商名字
            'seq': activeRangeList[index].sort                               #排序
            'startPrice': activeRangeList[index].startPrice               #起拍价
            'minPrice': activeRangeList[index].minPrice                    #最低价
            'downPiece': activeRangeList[index].downPiece                  #降价金额
            'stock': activeRangeList[index].perStock                           #活动商品数量
            'levelPrice': activeRangeList[index].levelPrice               #价格 （用于团购）
            'costBy': activeRangeList[index].costBy                         #费用承担方   0 行方 1 供应商
            'price': activeRangeList[index].price                             #秒杀价格
            'feeRange': activeRangeList[index].feeRange                     #降价金额 用于 荷兰拍
            'couponEnable': activeRangeList[index].couponEnable           #使用优惠券 用于 秒杀 (1 可以 0 不可以)
            'groupClassify': activeRangeList[index].groupClassify         #团购自己的分类 不是团购没有此值
          dataList[index] = dataTemp
        )
      else
        TipAndAlert.alert "body", "warning", "无活动选品"

      if selectVal is '荷兰拍'
        attribute = newActiveRangeSale(dataList)
        $('.activeRange-sale').append(attribute)
      else if selectVal is '团购'
        allGroupClassify=$(".activity-range").data("groupclassify")
        $.each(dataList,->
          @.classifyList=allGroupClassify
        )
        attribute = newActiveRangeGroupBy(dataList)
        $('.activeRange-groupBy').append(attribute)
      else if selectVal is '秒杀'
        attribute = newActiveRangeSecond(dataList)
        $('.activeRange-second').append(attribute)

    else if selectVal is '折扣' or selectVal is '满减'
      venderTemp = $('.active-range-title').data('data')
      if venderTemp != null
        supplierData = []
        venderTempList = venderTemp._DATA_.vendorIdNameDtos
        if venderTempList isnt undefined
          $.each(venderTempList, (index, item)->
            supplierTemp =
              'supplierName': venderTempList[index].simpleName
              'supplierCode': venderTempList[index].vendorId
            supplierData.push(supplierTemp)
          )
        else
          TipAndAlert.alert "body", "warning", "无供应商信息"

        if selectVal is '折扣'
          attribute = newActiveRangeDiscount(supplierData)
          $('.activeRange').append(attribute)
        else if selectVal is '满减'
          attribute = newActiveRangeFullDown(supplierData)
          $('.activeRange').append(attribute)



  # 改变活动时间，自动控制循环中每月的天数
  changeActiveDate: ->
    # 循环执行选中
    if $(".recycleActivity").is(':checked')
      # 选中每月
      if $(".byMonth").is(':checked')
        that.changeDayEvent()

  # 自动控制循环中最大的可选天数
  changeDayEvent: ->

    # 活动开始时间
    beginDate = $(".beginDate").val()
    # 活动结束时间
    endDate = $(".endDate").val()
    if beginDate != '' && endDate != ''
      activeBeginMonth = new Date(beginDate).getMonth()
      activeEndMonth = new Date(endDate).getMonth()
      curDate = new Date(beginDate)
      maxDayCount = new Date(curDate.getYear(), curDate.getMonth()+1, 0).getDate()
      # 开始结束日期在同一个月份
      if activeBeginMonth == activeEndMonth
        maxDayCount = new Date(endDate).getDate()
      # 取得期间每月最大天数
      while(curDate.getMonth() < activeEndMonth-1)
        curDate = new Date(curDate.getYear(), curDate.getMonth()+1, 1)
        if new Date(curDate.getYear(), curDate.getMonth()+1, 0).getDate() > maxDayCount
          maxDayCount = new Date(curDate.getYear(), curDate.getMonth()+1, 0).getDate()
      # 末月结束日大于前几月最大天数
      if new Date(endDate).getDate() > maxDayCount
        maxDayCount = new Date(endDate).getDate()

      _.each $(".dayCk"), (checkbox)->
        $(checkbox).attr("disabled",false)


      while maxDayCount < 31
        maxDayCount = maxDayCount + 1
        $(".day"+maxDayCount).attr("disabled",true)

# 1-31天
  dayInit: ->
    for i in [2..31]
      $('.day-copy').append '<span><input name="day" type="checkbox" class="dayCk day' + i + '">' + i + '</span>'

# 秒杀 团购 荷兰拍 活动范围  点击 新增
  addActiveGoods: ->
    activeType = $("#ForType").val()

    if activeType is '30' or activeType is '40' or activeType is '50'
      # 去重  要把table里的 单品编码  拼成 a,b 传给 接口
      itemCodeStr = ''
      $('.activeRange').find("tr").each (index) ->
        if index > 0 # 第一行是表头
          activity_add_ids += $(this).find("td").eq(4).text() + ','

    tempData = []
    $.ajax
      url: Store.context + "/api/admin/promotion/look-findItemListForProm"
      type: "POST"
      data: {
        'count': 50,
        'ruledOut': activity_add_ids
      }
      success: (data)=>
        tempData = data.data.result

        activityGoodsAdd = new Modal newActivityGoodsAdd(tempData)
        activityGoodsAdd.show()
        that.categoryInit() #新增 弹出窗口 后台类目初始化


# 活动范围  秒杀  点击删除
  deleteActivityRangeTable: ->
    $(this).parent().parent('.activeRuleTr').remove()

#活动范围 团购 点击删除
  activeRangeGroupbyDel: ->

#    $(this).parent().parent('.activeRuleTr').next().remove()
    $(this).parent().parent('.activeRuleTr').remove()

#活动优惠规则  点击 新增弹窗， 后台类目初始化
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

#活动优惠规则  点击 新增  弹窗中  后台类目联动
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

#活动类型 下拉框 onchange

  discountOff: ->
    data = $("#ForType").val()
    #若活动类型改变，活动范围数据不保留
    #活动类型改变  ， 活动优惠规则和活动范围也改变
    switch data
      when "10" #折扣
#活动优惠规则
        $(".active-sale-rule").empty()
        $(".active-sale-rule").append(newActiveSalePriceDiscount)
        #活动范围
        $('.activeRange').empty()
        $('.activeRange').append(newActiveRangeDiscount)

        $('.activeRangeAddBtn').hide()
        $('.fullDown-add-btn').hide()
        $(".activeRangeAddBtn-discount").show()
        $(".activeRangeAddBtn-fullDown").hide()
      when "20" #满减
#活动优惠规则
        $(".active-sale-rule").empty()
        $(".active-sale-rule").append(newActiveSaleRuleFullDown)
        #活动范围
        $('.activeRange').empty()
        $('.activeRange').append(newActiveRangeFullDown)

        $('.activeRangeAddBtn').hide()
        $('.fullDown-add-btn').show()
        $(".activeRangeAddBtn-discount").hide()
        $(".activeRangeAddBtn-fullDown").show()
      when "30" #秒杀
#活动优惠规则
        $(".active-sale-rule").empty()
        $(".active-sale-rule").append(newActiveSaleRuleSecond)
        #活动范围
        $('.activeRange').empty()
        $('.activeRange').append(newActivityRangeSecondThead)
        #        $('.activeRange-second').append(newActiveRangeSecond)

        $('.activeRangeAddBtn').show()
        $('.fullDown-add-btn').hide()
        $(".activeRangeAddBtn-discount").hide()
        $(".activeRangeAddBtn-fullDown").hide()
      when "40" #团购
#活动优惠规则
        $(".active-sale-rule").empty()
        $(".active-sale-rule").append(newActiveSaleRuleGroupBy)
        #活动范围
        $('.activeRange').empty()
        $('.activeRange').append(newActiveRangeGroupByThead)
        #        $('.activeRange-groupBy').append(newActiveRangeGroupBy)

        $('.activeRangeAddBtn').show()
        $('.fullDown-add-btn').hide()
        $(".activeRangeAddBtn-discount").hide()
        $(".activeRangeAddBtn-fullDown").hide()
      when "50" #荷兰拍
#活动优惠规则
        $(".active-sale-rule").empty()
        $(".active-sale-rule").append(newActiveSaleRuleSale)
        #活动范围
        $('.activeRange').empty()
        $('.activeRange').append(newActiveRangeSaleThead)

        $('.activeRangeAddBtn').show()
        $('.fullDown-add-btn').hide()
        $(".activeRangeAddBtn-discount").hide()
        $(".activeRangeAddBtn-fullDown").hide()


    $("form.newActivity-form").on "submit", @createActivity
  createActivity: (evt)->
    $.ajax
      url: Store.context + "/api/admin/newActivity"
      type: "POST"
      data: $("form.newActivity-form").serialize()
      success: (data)->
        window.location.reload()

  #活动优惠规则。 满减  点击新增按钮
  addFullDowmRole: ->
    #判断数量 最多10个
    if $('.fullDown-add').length < 10
      $(".active-sale-rule").append(newActiveSaleRuleFullDown)
    else
      TipAndAlert.alert "body", "error", "最多添加10个"

#满减  满减优惠 删除满减规则
  delFullDowmRole: ->
    if $('.fullDown-add').length is 1
      TipAndAlert.alert "body", "error", "已经是最后一个，不允许删除"
      return false
    $(this).parent().parent('.fullDown-add').remove()

# 折扣 满减 活动范围 ，  新增供应商

  activitySupplierAdd: ->
    #供应商ID
    IDTemp = ''
    if $("#ForType").val() is '10'
      $('.active-Range-Discount').each (index)->
        paramID = $(this).find(".suppID").text()
        IDTemp += paramID + ','
    else  if $("#ForType").val() is '20'
      $('.active-Range-FullDown').each (index)->
        paramID = $(this).find(".suppID").text()
        IDTemp += paramID + ','
    $.ajax
      url: Store.context + "/api/admin/promotion/add-findVenDtoByName"
      type: "POST"
      data: {
        'range': IDTemp
      }
      success: (data)=>
        supplierAdd = new Modal newSupplierAdd(data.data)
        supplierAdd.show()

# 折扣 满减 活动范围  选择供应商弹窗 点击确定
  discountFulldownSupplierWinOKFunc: ->
    supplierData = []
    _.each $(".js-check-this:checked"), (checkbox)->
      supplierTemp =
        'supplierName': $(checkbox).closest(".item-tr").find(".simpleName").text()
        'supplierCode': $(checkbox).closest(".item-tr").find(".vendorId").text()

      supplierData.push(supplierTemp)

    if $("#ForType").val() is '10' #折扣
      attribute = newActiveRangeDiscount(supplierData)
      $('.activeRange').append(attribute)
      $(".close").click()
    else if $("#ForType").val() is '20' #满减
      attribute = newActiveRangeFullDown(supplierData)
      $('.activeRange').append(attribute)
      $(".close").click()

  # 活动范围  折扣  删除
  activeRangeDiscountDel: ->
    $(this).parent().parent('.active-Range-Discount').remove()

  #活动范围 满减  删除
  activeRangeFullDownDel: ->
    $(this).parent().parent('.active-Range-FullDown').remove()

#活动范围  新增  弹窗  秒杀 团购 荷兰拍 点击确定
  addGoodsConfirmFunc: ->
    activeType = $("#ForType").val()
    dataList = []
    dataTemp = {}
    i = 0
    if activeType is '30' #秒杀
      count = $(".second-table").find("tr").length - 1
    else if activeType is '40' #团购
      count = $(".groupBy-table").find("tr").length - 1
    else if activeType is '50' #荷兰拍
      count = $(".sale-table").find("tr").length - 1

    _.each $(".js-check-this:checked"), (checkbox)->
      i++
      dataTemp =
        'index': ++count
        'itemCode': $(checkbox).closest(".item-tr").find(".itemCode").text()
        'backCategory': $(checkbox).closest(".item-tr").find(".backCategoryName").attr("data-category")
        'backCategoryName': $(checkbox).closest(".item-tr").find(".backCategoryName").text()
        'goodsName': $(checkbox).closest(".item-tr").find(".goodsName").text()
        'goodsBrandName': $(checkbox).closest(".item-tr").find(".goodsBrandName").text()
        'venderName': $(checkbox).closest(".item-tr").find(".venderName").text()
      dataTemp.itemCode = dataTemp.itemCode.replace(/(^\s*)|(\s*$)/g, "")
      dataList[i] = dataTemp

    #根据不同的活动类型   数据注入不同的模板
    if activeType is '30' #秒杀

      attribute = newActiveRangeSecond(dataList)
      $('.activeRange-second').append(attribute)
      $(".close").click()

    else if activeType is '40' #团购
      allGroupClassify=$(".activity-range").data("groupclassify")
      $.each(dataList,->
        @.classifyList=allGroupClassify
      )
      attribute = newActiveRangeGroupBy(dataList)
      $('.activeRange-groupBy').append(attribute)
      $(".close").click()

    else if activeType is '50' #荷兰拍
      attribute = newActiveRangeSale(dataList)
      $('.activeRange-sale').append(attribute)
      $(".close").click()

#活动优惠规则 新增 按钮  折扣 满减
  activityRangeAddDiscountFunc: ->
    activeType = $("#ForType").val()
    if activeType is '10' #折扣
      that.activitySupplierAdd()
    else if activeType is '20' #满减
      that.activitySupplierAdd()

#活动基本条件的 时间场次
  activityRuleTime: ->
    $(".js-date-start2").datepicker()
    $(".js-date-end2").datepicker()
    $(".js-date-start3").datepicker()
    $(".js-date-end3").datepicker()

#   活动基本条件  是否循环执行 checkbox onclick

  activityLoopFunc: ->
    if $('.recycleActivity').is(':checked')  # 若勾选  则循环执行  条件日期框show
      $('.limitRadioDay').show()
      $('.single-text').show()
      $('.dayWeekMonth').empty()
      $('.dayWeekMonth').append(newDayWeekMonth)
      $('.everyWeekOrMonth').empty()

      $('.loopTime').empty()
      $('.loopTime').append(newLoopTime)
      that.activityRuleTime()

    else
      $('.limitRadioDay').hide()
      $('.single-text').hide()
      $('.limitRadioActive').click()
      $('.dayWeekMonth').empty()
      $('.everyWeekOrMonth').empty()
      $('.loopTime').empty()

#循环执行勾选 每日 radiobutton onclick
  dayRadioOnclick: ->
    if $('.byDay').attr 'checked', 'checked'
      $('.everyWeekOrMonth').empty()

      $('.loopTime').empty()
      $('.loopTime').append(newLoopTime)
      that.activityRuleTime()

#循环执行勾选 每周 radiobutton onclick
  weekRadioOnclick: ->
    if $('.byWeek').attr 'checked', 'checked'
      $('.everyWeekOrMonth').empty()
      $('.everyWeekOrMonth').append(newByWeek)

      $('.loopTime').empty()
      $('.loopTime').append(newLoopTime)
      that.activityRuleTime()

#循环执行勾选 每月 radiobutton onclick
  monthRadioOnclick: ->
    if $('.byMonth').attr 'checked', 'checked'
      $('.everyWeekOrMonth').empty()
      $('.everyWeekOrMonth').append(newByMonth)
      that.dayInit()

      $('.loopTime').empty()
      $('.loopTime').append(newLoopTime)
      that.activityRuleTime()
      that.changeDayEvent()

# 新建活动 获取数据
  activeSave: (index)->

    #校验  活动基本信息
    checkFlag = false
    that.activeBaseInfoCheck()
    if checkFlag is true
      return

    #校验  活动优惠规则
    checkFlag = false
    that.activeRuleCheck()
    if checkFlag is true
      return

    param = {}
    # 保存 0   提交审核 1
    param.saveType = index
    if index is 0  #点击保存
      param.checkStatus = 0
    else if index is 1  #点击提交审核
      if $("#ForType").val() is '10' or $("#ForType").val() is '20'  #折扣满减  checkstate 传2  秒杀团购荷兰拍 checkstate 传5
        param.checkStatus = 2
      else
        param.checkStatus = 5

    #活动名称
    name = $('.active-name').val()
    nameLen = name.length
    if name == ''
      TipAndAlert.alert "body", "error", "活动名称不能为空"
      return
    if nameLen > 50
      TipAndAlert.alert "body", "error", "活动名称长度大于50"
      return
    param.name = name

    #活动简称
    shortName = $('.shortName').val()
    if shortName == ''
      TipAndAlert.alert "body", "error", "活动简称不能为空"
      return
    shortNameLen = shortName.length
    if shortNameLen > 25
      TipAndAlert.alert "body", "error", "活动简称长度大于25"
      return
    param.shortName = shortName

    #活动类型
    promType = $("#ForType").val()
    param.promType = promType

    #销售渠道
    sourceIdTemp = '||'
    $('.sale-channel').find("input").each (index) ->
      if $(this).is(':checked')  # （00商城，01CC，02IVR，03手机商城，04短信，05微信广发银行，06微信广发信用卡，09 APP）格式：||01||02||

        sourceIdTemp += '0' + index + '||'
    param.sourceId = sourceIdTemp

    #活动报名时间 开始时间
    beginEntryDate = $('.beginEntryDate').val()
    param.beginEntryDate = beginEntryDate
    #活动报名时间 结束时间
    endEntryDate = $('.endEntryDate').val()
    param.endEntryDate = endEntryDate

    #活动时间 开始时间
    beginDate = $('.beginDate').val()
    nowDate = that.getDate()
    if that.replaceDate(beginDate) <= that.replaceDate(nowDate)
      TipAndAlert.alert "body", "error", "活动开始时间不得小于当前时间"
      return
    param.beginDate = beginDate
    #活动开始时间要至少大于当前时间2天 check
    #活动时间 结束时间
    endDate = $('.endDate').val()
    param.endDate = endDate

    #是否循环执行
    if $('.recycleActivity').is(':checked')           # 值为d 按天循环;w 按星期循环；m 按月循环
      loopData = ''
      if $('.byDay').is(':checked')      # 每日
        loopType = 'd'
        loopData = ''                                      # 格式为选中项目序号使用,分割的字符串，例如【0,3】，表示第1项和第四项被选中
      else if $('.byWeek').is(':checked')  #每周
        loopType = 'w'
        $('.every-week').find("input").each (index) ->
          if $(this).is(':checked')
            loopData += index + 1 + ','

      else if $('.byMonth').is(':checked')  #每月
        loopType = 'm'
        $('.every-month').find("input").each (index) ->
          if $(this).is(':checked')
            loopData += index + 1 + ','

    param.loopType = loopType
    param.loopData = loopData

    if $(".recycleActivity").is(':checked')
      # 时间（场次1）
      loopBeginTimeHH1 = $('.loopBeginTimeHH1').val()
      loopBeginTimeMM1 = $('.loopBeginTimeMM1').val()
      loopEndTimeHH1 = $('.loopEndTimeHH1').val()
      loopEndTimeMM1 = $('.loopEndTimeMM1').val()

      ###四个选项都为空后台数据才有效###
      if loopBeginTimeHH1 isnt "" and loopBeginTimeMM1 isnt "" and loopEndTimeHH1 isnt "" and loopEndTimeMM1 isnt ""
        param.loopBeginTime1 = loopBeginTimeHH1+":"+loopBeginTimeMM1+":00"
        param.loopEndTime1 = loopEndTimeHH1+":"+loopEndTimeMM1+":00"

      #时间（场次2）
      loopBeginTimeHH2 = $('.loopBeginTimeHH2').val()
      loopBeginTimeMM2 = $('.loopBeginTimeMM2').val()
      loopEndTimeHH2 = $('.loopEndTimeHH2').val()
      loopEndTimeMM2 = $('.loopEndTimeMM2').val()

      ###四个选项都不为空后台数据才有效###
      if loopBeginTimeHH2 isnt "" and loopBeginTimeMM2 isnt "" and loopEndTimeHH2 isnt "" and loopEndTimeMM2 isnt ""
        param.loopBeginTime2 = loopBeginTimeHH2+":"+loopBeginTimeMM2+":00"
        param.loopEndTime2 = loopEndTimeHH2+":"+loopEndTimeMM2+":00"

    data = $("#ForType").val()
    #活动类型改变  ， 活动优惠规则 改变
    switch data
      when "10" #折扣
        ruleDiscountRate = $('.ruleDiscountRate').val()
        ruleLimitBuyCount = $('.ruleLimitBuyCount').val()
        if $('.limitRadioDay').is(':checked')
          ruleLimitBuyType = 0
        else
          ruleLimitBuyType = 1
        param.ruleDiscountRate = ruleDiscountRate
        param.ruleLimitBuyCount = ruleLimitBuyCount
        param.ruleLimitBuyType = ruleLimitBuyType
      when "20" #满减
        fullCut = []
        $('.fullDown-add').each (index) ->
          fullCutTemp =
            'full': $(this).find("input").eq(0).val()
            'cut': $(this).find("input").eq(1).val()
          fullCut.push(fullCutTemp)
          param.fullCut = JSON.stringify fullCut
      when "30" #秒杀
        ruleLimitBuyCount = $('.ruleLimitBuyCount').val()
        if $('.limitRadioDay').is(':checked')
          ruleLimitBuyType = 0
        else
          ruleLimitBuyType = 1

        param.ruleLimitBuyCount = ruleLimitBuyCount
        param.ruleLimitBuyType = ruleLimitBuyType
      when "40" #团购
        ruleLimitBuyCount = $('.ruleLimitBuyCount').val()
        if $('.limitRadioDay').is(':checked')
          ruleLimitBuyType = 0
        else
          ruleLimitBuyType = 1

        param.ruleLimitBuyCount = ruleLimitBuyCount
        param.ruleLimitBuyType = ruleLimitBuyType
      when "50" #荷兰拍

        ruleFrequency = $('.ruleFrequency').val()
        ruleLimitBuyCount = $('.ruleLimitBuyCount').val()
        ruleLimitTicket = $('.ruleLimitTicket').val()
        ruleGroupCount = $('.ruleGroupCount').val()
        if $('.limitRadioDay').is(':checked')
          ruleLimitBuyType = 0
        else
          ruleLimitBuyType = 1

        param.ruleLimitBuyType = ruleLimitBuyType
        param.ruleFrequency = ruleFrequency
        param.ruleLimitBuyCount = ruleLimitBuyCount
        param.ruleLimitTicket = ruleLimitTicket
        param.ruleGroupCount = ruleGroupCount

    #活动范围
    #折扣 ， 满减

    #供应商ID
    IDTemp = ''
    if $("#ForType").val() is '10'
      $('.active-Range-Discount').each (index)->
        paramID = $(this).find(".suppID").text()
        IDTemp += paramID + ','
    else  if $("#ForType").val() is '20'
      $('.active-Range-FullDown').each (index)->
        paramID = $(this).find(".suppID").text()
        IDTemp += paramID + ','

    param.range = IDTemp

    #秒杀 团购 荷兰拍
    if $("#ForType").val() is '30' #秒杀

      discount = []
      $('.second-table').find("tr").each (index)->
        if index > 0  #第一行是 表头
          # 判断优惠券
          if $(this).find("td").eq(10).find('.second-checkbox').is(':checked')
            couponEnable = 1
          else
            couponEnable = 0

          #判断 费用承担方
          if $(this).find("td").eq(7).find("input").eq(0).is(':checked')
            costBy = 0
          else
            costBy = 1
          discountTemp = {}
          discountTemp.seq = $(this).find("td").eq(1).find("input").val() #排序
          discountTemp.backCategory = $(this).find("td").eq(2).attr("data-category") #分类id
          discountTemp.selectCode = $(this).find("td").eq(4).text() #单品编码
          discountTemp.selectName = $(this).find("td").eq(5).text() #单品名称
          discountTemp.costBy = costBy #费用承担方 (0 行方 1 供应商)
          discountTemp.price = $(this).find("td").eq(8).find("input").val() #售价
          discountTemp.stock = $(this).find("td").eq(9).find("input").val() #活动商品数量
          discountTemp.couponEnable = couponEnable #使用优惠券 (1 可以 0 不可以)
          discountTemp.goodsCode = $(this).find("td:last").text()
          discount.push(discountTemp)

      param.range = JSON.stringify(discount)

    else if $("#ForType").val() is '40' #团购
      groupby = []
      $('.groupBy-table').find("tr").each (index)->
        if index > 0
          #判断 费用承担方
          if $(this).find("td").eq(7).find("input").eq(0).is(':checked')
            costBy = 0
          else
            costBy = 1

          groupbyTemp = {}
          groupbyTemp.seq = $(this).find("td").eq(1).find("input").val() #排序
          groupbyTemp.backCategory = $(this).find("td").eq(2).attr("data-category") #分类id
          groupbyTemp.selectCode = $(this).find("td").eq(4).html() #单品编码
          groupbyTemp.selectName = $(this).find("td").eq(5).html() #单品名称
          groupbyTemp.costBy = costBy #费用承担方 (0 行方 1 供应商)
          groupbyTemp.stock = $(this).find("td").eq(8).find("input").val() #活动商品数量
          groupbyTemp.levelPrice = $(this).find("td").eq(9).find("input").val() #团购价格
          groupbyTemp.groupClassify=$(@).find("td").eq(10).find("select").val() #团购类别
          groupbyTemp.goodsCode = $(this).find("td:last").text()
          groupby.push(groupbyTemp)
      param.range = JSON.stringify(groupby)

    else if $("#ForType").val() is '50' #荷兰拍
      sale = []
      $('.sale-table').find("tr").each (index)->
        if index > 0
          #判断 费用承担方 费用承担方固定是行方
          costBy = 0
          saleTemp = {}
          saleTemp.seq = $(this).find("td").eq(1).find("input").val() #排序
          saleTemp.backCategory = $(this).find("td").eq(2).attr("data-category") #分类id
          saleTemp.selectCode = $(this).find("td").eq(4).html() #单品编码
          saleTemp.selectName = $(this).find("td").eq(5).html() #单品名称
          saleTemp.costBy = costBy #费用承担方 (0 行方 1 供应商)
          saleTemp.startPrice = $(this).find("td").eq(8).find("input").val() #起拍价
          saleTemp.minPrice = $(this).find("td").eq(9).find("input").val() #最低价
          saleTemp.feeRange = $(this).find("td").eq(10).find("input").val() #最低价
          saleTemp.stock = $(this).find("td").eq(11).find("input").val() #活动商品数量
          saleTemp.goodsCode = $(this).find("td:last").text()
          sale.push(saleTemp)
      param.range = JSON.stringify(sale)

    #促销内容

    description = UM.getEditor('myEditor').getContent()
    if(description !=null and description.length >10000)
      TipAndAlert.alert "body", "error", "促销内容过长"
      return
    description = description.replace(/<.*?>/ig,"")
    param.description = description

    # 活动ID
    id = $('.active-range-title').data('data')._DATA_.adminPromotionResultDto.id
    param.id = id
    param.createOperType="0"
    $.ajax
      url: Store.context + "/api/admin/promotion/update"
      type: "POST"
      data:param
      success: (data)=>
        if data.data.length > 0
          new Modal(activityAlertMsg({content:data.data})).show()
          $(".js-activity-ok").on "click",->
            window.location.href=Store.context + "/mall/activity/activity_all"
        else
          window.location.href=Store.context + "/mall/activity/activity_all"


  # 点击提交审核
  activeSubmitAudit: (evt)->
#    evt.preventDefault()
    $("form.newActivity-add-form").validator
      isErrorOnParent: true
    that.activeSave(1)
  #点击保存
  activeSaveClick: (evt)->
#    evt.preventDefault()
    $("form.newActivity-add-form").validator
      isErrorOnParent: true
    that.activeSave(0)

  #校验活动基本信息
  activeBaseInfoCheck: (evt)->
    # 销售渠道
    noCheckedSourceId = true
    _.each $(".source:checked"), (checkbox)->
      noCheckedSourceId = false
    if noCheckedSourceId
      TipAndAlert.alert "body", "error", "至少选择一种销售渠道"
      checkFlag = true
      return

    # 报名开始时间
    beginEntryDate = $(".beginEntryDate").val()
    # 报名结束时间
    endEntryDate = $(".endEntryDate").val()

    if beginEntryDate isnt ''
      if beginEntryDate >= endEntryDate
        TipAndAlert.alert "body", "error", "报名结束时间不得早于报名开始时间"
        checkFlag = true
        return

    # 活动开始时间
    beginDate = $(".beginDate").val()
    # 活动结束时间
    endDate = $(".endDate").val()
    # 活动结束时间不得早于活动开始时间
    if beginDate >= endDate
      TipAndAlert.alert "body", "error", "活动结束时间不得早于活动开始时间"
      checkFlag = true
      return

    # 循环执行checkbox选中
    if $(".recycleActivity").is(':checked')
      # 选中每周
      if $(".byWeek").is(':checked')
        # check周一至周日checkbox
        noCheckedWeek = true
        _.each $(".weekCk:checked"), (checkbox)->
          noCheckedWeek = false
        if noCheckedWeek
          TipAndAlert.alert "body", "error", "每周至少选择一天"
          checkFlag = true
          return
      # 选中每月
      if $(".byMonth").is(':checked')
        # check 1至31日
        noCheckedDay = true
        _.each $(".dayCk:checked"), (checkbox)->
          noCheckedDay = false
        if noCheckedWeek
          TipAndAlert.alert "body", "error", "每月至少选择一天"
          checkFlag = true
          return

      # 场次一开始时间
      loopBeginTimeHH1 = $('.loopBeginTimeHH1').val()
      loopBeginTimeMM1 = $('.loopBeginTimeMM1').val()
      loopEndTimeHH1 = $('.loopEndTimeHH1').val()
      loopEndTimeMM1 = $('.loopEndTimeMM1').val()

      ###四个选项都为空后台数据才有效###
      ###有一个不为空 其他三个必须都存在才有效###

      if loopBeginTimeHH1 isnt "" or loopBeginTimeMM1 isnt "" or loopEndTimeHH1 isnt "" or loopEndTimeMM1 isnt ""
        if loopBeginTimeHH1 isnt "" and loopBeginTimeMM1 isnt "" and loopEndTimeHH1 isnt "" and loopEndTimeMM1 isnt ""
          loopBeginTime1 = loopBeginTimeHH1+":"+loopBeginTimeMM1+":00"
          loopEndTime1 = loopEndTimeHH1+":"+loopEndTimeMM1+":00"
          beginTimestamp1=moment({hour: loopBeginTimeHH1, minute: loopBeginTimeMM1, seconds: 0}).valueOf();
          endTimestamp1=moment({hour: loopEndTimeHH1, minute: loopEndTimeMM1, seconds: 0}).valueOf();

          if beginTimestamp1 >= endTimestamp1
            TipAndAlert.alert "body", "error", "场次一的结束时间不得早于开始时间"
            checkFlag = true
            return
        else
          TipAndAlert.alert "body", "error", "场次一时间选择不正确"
          checkFlag = true
          return
      else
        TipAndAlert.alert "body", "error", "请选择循环时间"
        checkFlag = true
        return
      # 场次二开始时间
      loopBeginTimeHH2 = $('.loopBeginTimeHH2').val()
      loopBeginTimeMM2 = $('.loopBeginTimeMM2').val()
      loopEndTimeHH2 = $('.loopEndTimeHH2').val()
      loopEndTimeMM2 = $('.loopEndTimeMM2').val()
      ###四个选项都不为空后台数据才有效###
      ###有一个不为空 其他三个必须都存在才有效###
      if loopBeginTimeHH2 isnt "" or loopBeginTimeMM2 isnt "" or loopEndTimeHH2 isnt "" or loopEndTimeMM2 isnt ""
        if loopBeginTimeHH2 isnt "" and loopBeginTimeMM2 isnt "" and loopEndTimeHH2 isnt "" and loopEndTimeMM2 isnt ""
          loopBeginTime2 = loopBeginTimeHH2+":"+loopBeginTimeMM2+":00"
          loopEndTime2 = loopEndTimeHH2+":"+loopEndTimeMM2+":00"
          beginTimestamp2=moment({hour: loopBeginTimeHH2, minute: loopBeginTimeMM2, seconds: 0}).valueOf();
          endTimestamp2=moment({hour: loopEndTimeHH2, minute: loopEndTimeMM2, seconds: 0}).valueOf();
          if beginTimestamp2 >= endTimestamp2
            TipAndAlert.alert "body", "error", "场次二的结束时间不得早于开始时间"
            checkFlag = true
            return
          if loopBeginTimeHH1 isnt "" and loopBeginTimeMM1 isnt "" and loopEndTimeHH1 isnt "" and loopEndTimeMM1 isnt ""
            loopBeginTime1 = loopBeginTimeHH1+":"+loopBeginTimeMM1+":00"
            loopEndTime1 = loopEndTimeHH1+":"+loopEndTimeMM1+":00"
            beginTimestamp1=moment({hour: loopBeginTimeHH1, minute: loopBeginTimeMM1, seconds: 0}).valueOf();
            endTimestamp1=moment({hour: loopEndTimeHH1, minute: loopEndTimeMM1, seconds: 0}).valueOf();
            if endTimestamp1 >= beginTimestamp2
              TipAndAlert.alert "body", "error", "两场时间有重合"
              checkFlag = true
              return
        else
          TipAndAlert.alert "body", "error", "场次二时间选择不正确"
          checkFlag = true
          return

  #校验  活动优惠规则
  activeRuleCheck: ->
    #折扣比例
    discountRate = $('.ruleDiscountRate').val()
    if $("#ForType").val() is '10' #折扣
      if !$('.ruleLimitBuyCount').val()
        $('.ruleLimitBuyCount').parent().addClass("red")
        TipAndAlert.alert "body", "error", "新建失败","限购数量不能为空"
        checkFlag = true
        return
      $('.ruleDiscountRate').parent().removeClass("red")
      if that.isNum(discountRate)     #判断为数字
        if discountRate <= 0 or  discountRate >=1
          TipAndAlert.alert "body", "error", "新建失败","请填写大于0小于1的折扣比例"
          $('.ruleDiscountRate').parent().addClass("red")
          checkFlag = true
          return
      else
        $('.ruleDiscountRate').parent().addClass("red")
        TipAndAlert.alert "body", "error", "新建失败","折扣比例请填写数字"
        checkFlag = true
        return

      # 限购数量  （大于等于1 的正整数）
      if $('.ruleLimitBuyCount').val() isnt ''
        $('.ruleLimitBuyCount').parent().removeClass("red")
        buyCount = that.isPositiveIntegers($('.ruleLimitBuyCount').val())
        if !buyCount
          $('.ruleLimitBuyCount').parent().addClass("red")
          TipAndAlert.alert "body", "error", "新建失败","限购数量不正确"
          checkFlag = true
          return

    else if $("#ForType").val() is '20' #满减
      allFullVal = '' #用作 满减中  满  每条的满  不重复
      $('.fullDown-add').each (index) ->
        $(this).removeClass("red")

        fullVal = $(this).find('input:first').val()
        cutVal = $(this).find('input:last').val()
        # 判断满减  值  满   重复
        if allFullVal.indexOf(String(fullVal)) > 0
          TipAndAlert.alert "body", "error", "新建失败","满减值重复"
          $(this).addClass("red")
          checkFlag = true
          return

        allFullVal += fullVal + ','
        #判断是否为正整数
        if that.isPositiveIntegers2(fullVal) and that.isPositiveIntegers2(cutVal)

          if Number(fullVal) < Number(cutVal)
            $(this).addClass("red")
            TipAndAlert.alert "body", "error", "新建失败","满减值不正确"
            checkFlag = true
            return
        else
          $(this).addClass("red")
          TipAndAlert.alert "body", "error", "新建失败","满减值不正确"
          checkFlag = true
          return
#      console.log(allFullVal)

    else if $("#ForType").val() is '30'#秒杀
      if !$('.ruleLimitBuyCount').val()
        $('.ruleLimitBuyCount').parent().addClass("red")
        TipAndAlert.alert "body", "error", "新建失败","限购数量不能为空"
        checkFlag = true
        return
      # 限购数量  （大于等于1 的正整数）
      if $('.ruleLimitBuyCount').val() isnt ''
        $('.ruleLimitBuyCount').parent().removeClass("red")
        buyCount = that.isPositiveIntegers($('.ruleLimitBuyCount').val())
        if !buyCount
          $('.ruleLimitBuyCount').parent().addClass("red")
          TipAndAlert.alert "body", "error", "新建失败","限购数量不正确"
          checkFlag = true
          return

      #活动范围
      if $('.activeRange').find("tr").length is 1
        TipAndAlert.alert "body", "error", "新建失败","活动范围不能为空"
        checkFlag = true
        return

      rangeOrderSecond = ''  #用于秒杀 活动范围 排序 校验是否有重复
      $('.activeRange').find("tr").each (index) ->
        #售价
        if index > 0
          priceSecond = $(this).find("td").eq(8).find("input").val()
          $(this).removeClass("red")
          #判断是否为正数
          priceCheck = that.isNumber(priceSecond)
          if !priceCheck or Number(priceSecond) < 0
            $(this).addClass("red")
            TipAndAlert.alert "body", "error", "新建失败","活动价不正确"
            checkFlag = true
            return

          #活动商品数量
          activeGoodsCountSecond = $(this).find("td").eq(9).find("input").val()
          #判断是否为大于等于一的正整数
          activeGoodsCountSecondCheck = that.isPositiveIntegers(activeGoodsCountSecond)
          if !activeGoodsCountSecondCheck
            $(this).addClass("red")
            TipAndAlert.alert "body", "error", "新建失败","活动商品数量不正确"
            checkFlag = true
            return

          # 排序
          orderEach = $(this).find("td").eq(1).find("input").val()
          orderEachCheck = that.isPlus(orderEach)
          if !orderEachCheck   #判断正整数
            $(this).addClass("red")
            TipAndAlert.alert "body", "error", "新建失败","排序值不正确"
            checkFlag = true
            return
          #排序  判断重复
          if rangeOrderSecond.indexOf(String(orderEach)) >= 0
            $(this).addClass("red")
            TipAndAlert.alert "body", "error", "新建失败","排序值不正确"
            checkFlag = true
            return
          rangeOrderSecond += orderEach + ','

    else if $("#ForType").val() is '40'#团购
      if !$('.ruleLimitBuyCount').val()
        $('.ruleLimitBuyCount').parent().addClass("red")
        TipAndAlert.alert "body", "error", "新建失败","限购数量不能为空"
        checkFlag = true
        return
      # 限购数量  （大于等于1 的正整数）
      if $('.ruleLimitBuyCount').val() isnt ''
        $('.ruleLimitBuyCount').parent().removeClass("red")
        buyCount = that.isPositiveIntegers($('.ruleLimitBuyCount').val())
        if !buyCount
          $('.ruleLimitBuyCount').parent().addClass("red")
          TipAndAlert.alert "body", "error", "新建失败","限购数量不正确"
          checkFlag = true
          return

      # 活动范围

      if $('.activeRange').find("tr").length is 1
        TipAndAlert.alert "body", "error", "新建失败","活动范围不能为空"
        checkFlag = true
        return
      rangeOrderGroupby = ''   # 用于  团购 活动范围 排序 查重
      $('.activeRange').find("tr").each (index) ->
        if index > 0
          $(this).removeClass("red")

          #活动商品数量
          activeGoodsCountFullDown = $(this).find("td").eq(8).find("input").val()
          #判断是否为正整数
          activeGoodsCountFullDownCheck = that.isPlus(activeGoodsCountFullDown)
          if !activeGoodsCountFullDownCheck
            $(this).addClass("red")
            TipAndAlert.alert "body", "error", "新建失败","活动商品数量不正确"
            checkFlag = true
            return

          #团购价格
          priceFullDown = $(this).find("td").eq(9).find("input").val()
          #判断是否为正数
          priceFullDownCheck = that.isNumber(priceFullDown)
          if !priceFullDownCheck or Number(priceFullDown) < 0
            $(this).addClass("red")
            TipAndAlert.alert "body", "error", "新建失败","团购价格不正确"
            checkFlag = true
            return
          #团购自己的分类
          rangeGroupClassifyCheck=$(@).find("td").eq(10).find("select").val()
          if _.isEmpty(rangeGroupClassifyCheck)
            TipAndAlert.alert "body", "error", "新建失败","团购商品类别必选"
            checkFlag = true
            return
          #排序
          orderEachFulldown = $(this).find("td").eq(1).find("input").val()
          #判断正整数
          orderEachFulldownCheck = that.isPlus(orderEachFulldown)
          if !orderEachFulldownCheck
            $(this).addClass("red")
            TipAndAlert.alert "body", "error", "新建失败","排序值不正确"
            checkFlag = true
            return
          #判断重复
          if rangeOrderGroupby.indexOf(String(orderEachFulldown)) >= 0
            $(this).addClass("red")
            TipAndAlert.alert "body", "error", "新建失败","排序值不正确"
            checkFlag = true
            return
          rangeOrderGroupby += orderEachFulldown + ','

    else if $("#ForType").val() is '50' # 荷兰拍
      #降价频率
      downPriceRaceSale = that.isPlus($('.ruleFrequency').val())
      $('.ruleFrequency').parent().removeClass("red")
      if !downPriceRaceSale
        $('.ruleFrequency').parent().addClass("red")
        TipAndAlert.alert "body", "error", "新建失败","降价频率输入有误"
        checkFlag = true
        return
      #限购数量
      limitBuyCountSale = that.isPositiveIntegers($('.ruleLimitBuyCount').val())
      $('.ruleLimitBuyCount').parent().removeClass("red")
      if !limitBuyCountSale
        $('.ruleLimitBuyCount').parent().addClass("red")
        TipAndAlert.alert "body", "error", "新建失败","限购数量不正确"
        checkFlag = true
        return
      #可拍次数
      ruleLimitTicketSale = that.isPositiveIntegers($('.ruleLimitTicket').val())
      $('.ruleLimitTicket').parent().removeClass("red")
      if !ruleLimitTicketSale
        $('.ruleLimitTicket').parent().addClass("red")
        TipAndAlert.alert "body", "error", "新建失败","可拍次数值不正确"
        checkFlag = true
        return
      #可拍次数  大于 限购数量
      limitNum = $('.ruleLimitBuyCount').val()
      auctionNum = $('.ruleLimitTicket').val()
      if Number(limitNum) > Number(auctionNum)
        $('.ruleLimitTicket').parent().addClass("red")
        TipAndAlert.alert "body", "error", "新建失败","可拍次数值不正确"
        checkFlag = true
        return

      #活动范围
      if $('.activeRange').find("tr").length is 1  #第一行为 表头  不能为空
        TipAndAlert.alert "body", "error", "新建失败","活动范围不能为空"
        checkFlag = true
        return

      rangeOrderSale = ''
      $('.activeRange').find("tr").each (index) ->
        if index > 0
          $(this).removeClass("red")
          #起拍价
          startPriceSale = $(this).find("td").eq(8).find("input").val()
          #判断是否为正数
          startPriceSaleCheck = that.isNumber(startPriceSale)
          if !startPriceSaleCheck or Number(startPriceSale) < 0
            $(this).addClass("red")
            TipAndAlert.alert "body", "error", "新建失败","起拍价值不正确"
            checkFlag = true
            return
          #最低价
          downPriceSale = $(this).find("td").eq(9).find("input").val()
          #判断是否为正数
          downPriceSaleCheck = that.isNumber(downPriceSale)
          if !downPriceSaleCheck or Number(downPriceSale) < 0
            $(this).addClass("red")
            TipAndAlert.alert "body", "error", "新建失败","最低价值不正确"
            checkFlag = true
            return
          #最低价要小于起拍价
          if Number(downPriceSale) > Number(startPriceSale)
            $(this).addClass("red")
            TipAndAlert.alert "body", "error", "新建失败","最低价值不正确"
            checkFlag = true
            return
          #降价金额
          downPricePerSale = $(this).find("td").eq(10).find("input").val()
          #判断是否为正数
          downPricePerSaleCheck = that.isNumber(downPricePerSale)
          if !downPricePerSaleCheck or Number(downPricePerSale) < 0
            $(this).addClass("red")
            TipAndAlert.alert "body", "error", "新建失败","降价金额值不正确"
            checkFlag = true
            return
          #降价金额要小于起拍价
          if Number(downPricePerSale) > Number(startPriceSale)
            $(this).addClass("red")
            TipAndAlert.alert "body", "error", "新建失败","降价金额值不正确"
            checkFlag = true
            return
          #活动商品数量
          activeGoodsCountSale = $(this).find("td").eq(11).find("input").val()
          #判断是否为正整数
          activeGoodsCountSaleCheck = that.isPlus(activeGoodsCountSale)
          if !activeGoodsCountSaleCheck or Number(activeGoodsCountSale) < 0
            $(this).addClass("red")
            TipAndAlert.alert "body", "error", "新建失败","活动商品数量值不正确"
            checkFlag = true
            return
          #排序
          orderEachSale = $(this).find("td").eq(1).find("input").val()
          #判断正整数
          orderEachSaleCheck = that.isPlus(orderEachSale)
          if !orderEachSaleCheck
            $(this).addClass("red")
            TipAndAlert.alert "body", "error", "新建失败","排序值不正确"
            checkFlag = true
            return
          #判断重复
          if rangeOrderSale.indexOf(String(orderEachSale)) >= 0
            $(this).addClass("red")
            TipAndAlert.alert "body", "error", "新建失败","排序值不正确"
            checkFlag = true
            return
          rangeOrderSale += orderEachSale + ','


  # 取消  onclick
  buttonCancle: ->
    window.location.href=Store.context + "/mall/activity/activity_all"

  #获取 字符长度
  characterLength: (val) ->
    i = 0
    realLength = 0
    while i < val.length
      charCode = val.charCodeAt(i)
      if charCode > 0 and charCode <= 128
        realLength += 1
      else
        realLength += 2
      i++
    return realLength

  #判断为数字
  isNum: (param)->
    num = /^-?\d+(?:\.\d+)?$/
    return num.test(param)

  #大于等于1 的正整数
  isPositiveIntegers: (param)->
    num = /^\+?[1-9]\d*$/
    return num.test(param)

  #判断是否为正整数
  isPositiveIntegers2: (param)->
    num = /^[1-9]*[1-9][0-9]*$/
    return num.test(param)

  #判断是否为正整数
  isPlus: (param)->
    num = /^(-)?[1-9][0-9]*$/
    return num.test(param)

  #判断是否为正数
  isNumber: (param)->
    num = /\d+(\.\d{0,2})?/
    return num.test(param)

#  #判断日期是否合法
#  isDate: (param)->
#    num = /((^((1[8-9]\d{2})|([2-9]\d{3}))([-\/\._])(10|12|0?[13578])([-\/\._])(3[01]|[12][0-9]|0?[1-9])$)|(^((1[8-9]\d{2})|([2-9]\d{3}))([-\/\._])(11|0?[469])([-\/\._])(30|[12][0-9]|0?[1-9])$)|(^((1[8-9]\d{2})|([2-9]\d{3}))([-\/\._])(0?2)([-\/\._])(2[0-8]|1[0-9]|0?[1-9])$)|(^([2468][048]00)([-\/\._])(0?2)([-\/\._])(29)$)|(^([3579][26]00)([-\/\._])(0?2)([-\/\._])(29)$)|(^([1][89][0][48])([-\/\._])(0?2)([-\/\._])(29)$)|(^([2-9][0-9][0][48])([-\/\._])(0?2)([-\/\._])(29)$)|(^([1][89][2468][048])([-\/\._])(0?2)([-\/\._])(29)$)|(^([2-9][0-9][2468][048])([-\/\._])(0?2)([-\/\._])(29)$)|(^([1][89][13579][26])([-\/\._])(0?2)([-\/\._])(29)$)|(^([2-9][0-9][13579][26])([-\/\._])(0?2)([-\/\._])(29)$))/
#    return !num.test(param)

  #时间格式转换
  dateFormatChange: (num)->

    num = num + ' '
    date = ''
    month = new Array
    month['Jan'] = '01'
    month['Feb'] = '02'
    month['Mar'] = '03'
    month['Apr'] = '04'
    month['May'] = '05'
    month['Jun'] = '06'
    month['Jul'] = '07'
    month['Aug'] = '08'
    month['Sep'] = '09'
    month['Oct'] = '10'
    month['Nov'] = '11'
    month['Dec'] = '12'
    week = new Array
    week['Mon'] = '一'
    week['Tue'] = '二'
    week['Wed'] = '三'
    week['Thu'] = '四'
    week['Fri'] = '五'
    week['Sat'] = '六'
    week['Sun'] = '日'
    str = num.split(' ')
    date = str[5] + '-'
    date = date + month[str[1]] + '-' + str[2]
    return date

  # 互动范围 选品弹窗 点击 搜索按钮
  addGoodsSearchFunc: ->
    tempData = []
    $.ajax
      url: Store.context + "/api/admin/promotion/look-findItemListForProm"
      type: "POST"
      dataType:"json"
      data: {
        'vendorName':$(".add-goods-vendor").val(),
        'goodsName':$(".add-goods-name").val(),
        'brandName':$(".add-goods-brand").val(),
        'backCategory1':$(".js-select1").val(),
        'backCategory2':$(".js-select2").val(),
        'backCategory3':$(".js-select3").val(),
        'ruledOut': activity_add_ids
      }
      success: (data)=>
        tempData = data.data.result
        attribute = newActivityGoodsAddSearch(tempData)
        $('.data_div').empty()
        $('.data_div').append(attribute)

  #获取当前时间
  getDate: ->
    myDate = new Date()
    year = myDate.getFullYear()
    month = myDate.getMonth() + 1
    if month < 10
      month = '0' + month
    day = myDate.getDate()
    if day < 10
      day = '0' + day
    hour = myDate.getHours()
    if hour < 10
      hour = '0' + hour
    minute = myDate.getMinutes()
    if minute < 10
      minute = '0' + minute
    second = myDate.getSeconds()
    if second < 10
      second = '0' + second

    nowDate = year + '-' + month + '-' + day + ' ' + hour + ':' + minute + ':' + second

    return nowDate

  #日期转化成长日期格式
  replaceDate: (param)->
    return param.replace(/\-/g, "\/")
  rangeModelCancel: ->
    $('.activityGoodsAddModal').find('.modal-header').find('.close').click()


module.exports = activity_edit

