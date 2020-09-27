Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"
class coupon_set
  vendorNames = ''
  vendorIds = ''
  brandNames = ''
  brandIds = ''
  goodsNames = ''
  goodsIds = ''
  backCategoryNms = ''
  backCategoryIds = ''
  treeObj = null
  _.extend @::, TipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show()
#  startPicker = null
#  endPicker = null

  #  startpicker = new Pikaday({field: $(".js-date-start1")[0]});
  # endpicker = new Pikaday({field: $(".js-date-end")[0]});
  constructor: ->
    @couponSet = ".js-coupon-add"
    @isManualBtn = ".is-manual"
    @vendorSelect = ".js-vendor-select"
    @searchBtn = ".js-search-btn"
    @vendorName = ".js-save-vendorName" #选择供应商
    @category = ".js-save-category" #选择类目
    @goodsName = ".js-save-goodsName" #选择商品
    @brandName = ".js-save-brandName" #选择品牌
    @saveCoupon = ".js-coupon-save"
    @checkboxStyle = ".js-checkBox-style"
    datas = $(".trData").data("data")
    vendorNames = datas.vendorNms
    vendorIds = $("#vendorNmss").data("id")
    brandNames = datas.brandName
    brandIds = $("#brandNamess").data("id")
    goodsNames = datas.goodsName
    goodsIds = $("#goodsNamess").data("id")
    backCategoryNms = datas.backCategoryNm
    backCategoryIds = $("#backCategoryNmss").data("id")
    start = {
      elem: '#startTimes',
      format:  'YYYY-MM-DD hh:mm:ss', #自动生成的时间格式
      istime: true, #必须填入时间
    }
    end = {
      elem: '#endTimes',
      format:  'YYYY-MM-DD hh:mm:ss', #自动生成的时间格式
      istime: true, #必须填入时间
    }
    laydate(start)
    laydate(end)

#    startPicker = new Pikaday(
#      field:  $(".js-date-start")[0]
#      i18n: {
#        previousMonth: "上月",
#        nextMonth: "下月",
#        months: [ "一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月" ],
#        weekdays: [ "周日", "周一", "周二", "周三", "周四", "周五", "周六" ],
#        weekdaysShort: [ "日", "一", "二", "三", "四", "五", "六" ]
#      }
#      onSelect: ->
#        startDate = ($(".js-date-start").val()).replace(/-/g,"/")
#        endPicker.setMinDate(new Date(startDate))
#    )
#    endPicker = new Pikaday(
#      field: $(".js-date-end")[0]
#      i18n: {
#        previousMonth: "上月",
#        nextMonth: "下月",
#        months: [ "一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月" ],
#        weekdays: [ "周日", "周一", "周二", "周三", "周四", "周五", "周六" ],
#        weekdaysShort: [ "日", "一", "二", "三", "四", "五", "六" ]
#      }
#      onSelect: ->
#        endDate = ($(".js-date-end").val()).replace(/-/g,"/")
#        startPicker.setMaxDate(new Date(endDate))
#    )

    @bindEvent()
    @firstLoginInit()
  selectVendorsResultTemplate = App.templates["select_vendors"] #供应商
  modalVendorsResultTemplate = App.templates["data_vendor"] #供应商数据
  selectCategoryResultTemplate = App.templates["select_category"] #类目
  selectGoodsResultTemplate = App.templates["select_goods"] #商品
  modalGoodsResultTemplate = App.templates["data_goods"] #商品数据
  selectBrandsResultTemplate = App.templates["select_brands"] #品牌
  modalBrandsResultTemplate = App.templates["data_brand"] #品牌数据
  setTemplate = App.templates["coupon_set"]
  that = this
  bindEvent: ->
    that = this
    $(".coupons_set").on "click", @couponSet, @settingCoupon
    $(".coupons_set").on "click", @checkboxStyle, @styleCheckbox
    $(".coupons_set").on "click", @isManualBtn, @firstLoginToggle
    $(document).on "click", @vendorSelect, @categorySelect #查询供应商
    $(document).on "click", @searchBtn, @categorySelect #查询按钮通用
    $(document).on "click", @vendorName, @saveVendorName
    $(document).on "click", @category, @saveCategory
    $(document).on "click", @goodsName, @saveGoodsName
    $(document).on "click", @brandName, @savBrandsName
    $(document).on "change", ".optCodebox", @optCodeChange
    $("form.coupon-add-form").on "submit", that.couponSaveConfirm



  # 初始化显示控制  by geshuo 20160806
  firstLoginInit: (evt)->
    isManual = $("#isFirstlogin").data("manual")+""
    if isManual isnt '1' #不手动领取，显示首次登录设定
      if $("#isFirstlogin").val() is '1' # 首次登录已设置
        $(".disStyle").show() # geshuo 20160807
      else
        $(".disStyle").hide() # geshuo 20160807
    else
      $(".js-first-login").hide()
      $(".disStyle").show()
#      $(".disStyle").hide() # geshuo 20160807

  # 是否手动领取 选中事件
  firstLoginToggle: (evt)->
    if $(@).val() is '0' #不手动领取，显示推送范围
      $(".js-first-login").show()
      $(".disStyle").hide()
    else # 需要手动领取 ，设置有效时间
      $(".js-first-login").hide()
      $("#isFirstlogin").prop('checked', false)
#      $(".disStyle").hide() # geshuo 20160807
      $(".disStyle").show()
      $("#startTimes").val('')
      $("#endTimes").val('')


  settingCoupon: ->
    data = $(@).closest("tr").data("data")
    coupon = new Modal(setTemplate(data)).show()
    $("form.coupon-form").validator()
    $("form.coupon-form").on "submit", that.editConfirm

  editConfirm: (event)->
    $("form.coupon-form").validator();
    event.preventDefault()
    $.ajax
      url: Store.context + "/api/admin/coupon"
      type: "POST"
      data: $("form.coupon-form").serialize()
      success: (data)->
        window.location.reload()

  categorySelect: (evt)->
    evt.preventDefault()
    classifications = $(@).data("value")
    searchKey = $(".js-search-value1").val()
    if searchKey is undefined
      searchKey = ""

    if classifications is 2 and $(".modal").length isnt 0
      #Ztree模糊搜索
      search_ztree("treeResource","searchKey")
      return
    $.ajax
      url: Store.context + "/api/admin/specialPointsRate/add-findClassifications"
      type: "POST"
      dataType: "JSON"
      data:
        "type": classifications, searchKey: searchKey
      success: (data)->
        #供应商
        if classifications is 0
          if $(".modal").length is 0 #当前没有对话框显示
            component = new Modal selectVendorsResultTemplate({list: data.data.result.vendorInfoModelList})
            component.show()
          else
            $(".setting-scrll").html(modalVendorsResultTemplate({list: data.data.result.vendorInfoModelList}))
          vendorIds = $("#vendorNmss").data("id")
          that.optModelChange("vendor",vendorIds,$('#vendorNms').val())
        #品牌
        if classifications is 1
          if $(".modal").length is 0 #当前没有对话框显示
            component = new Modal selectBrandsResultTemplate({list: data.data.result.goodsBrandModelList})
            component.show()
          else
            $(".setting-scrll").html(modalBrandsResultTemplate({list: data.data.result.goodsBrandModelList}))
          brandIds = $("#brandNamess").data("id")
          that.optModelChange("brand",brandIds,$('#brandName').val())
        #类目
        if classifications is 2
          treeData = data.data.result.backCategoryList
          setting =
            view:
              nameIsHTML: true
              fontCss: setFontCss_ztree
            data:
              simpleData:
                enable: true
                idKey: "id"
                pIdKey: "parentId"
                rootPId: null
            check:
              enable: true
              autoCheckTrigger: true
          if $(".modal").length is 0 #当前没有对话框显示
            component = new Modal selectCategoryResultTemplate(data.treeObj)
            component.show()
          treeObj = $.fn.zTree.init($("#treeResource"), setting, treeData)
          backCategoryIds = $("#backCategoryNmss").data("id")+""
          if backCategoryIds
            idArray = backCategoryIds.split("、")
            $.each(idArray, (index, item)->
              selectId = item+""
              if selectId
                node = treeObj.getNodeByParam("id", selectId)
                treeObj.selectNode (node)
                treeObj.checkNode (node)
            )
        #商品
        if classifications is 3
          if $(".modal").length is 0 #当前没有对话框显示
            component = new Modal selectGoodsResultTemplate({list: data.data.result.goodsModelList})
            component.show()
          else
            $(".setting-scrll").html(modalGoodsResultTemplate({list: data.data.result.goodsModelList}))
          goodsIds = $("#goodsNamess").data("id")+""
          that.optModelChange("goods",goodsIds,$('#goodsName').val())

#选择变化处理
  optModelChange:(type , olddata ,olddataName)->
    first = $(".optCodes").data("first")
    newcode = $(".optCodes").data("optcodes")
    newname = $(".optCodes").data("optnames")
    if first is "0" || first is 0
      newname = olddataName
      newcode = olddata
      $(".optCodes").data("first",'1')
    newname = newname+""
    newcode = newcode+""
    $(".optCodes").data("optnames",newname)
    $(".optCodes").attr("title",newname)
    $(".optCodes").html(newname)
    $(".optCodes").data("optcodes",newcode)
    idArray = []
    if newcode.indexOf("、") isnt -1
      idArray = newcode.split("、")
    else if newcode != ""
      idArray.push(newcode)
    if type is "goods"
      $.each(idArray, (index, item)->
        selectId = item + ""
        $("input[name='goodsNames']").each ->
          goodsId = $(@).attr("data-id")
          if goodsId is selectId
            $(@).prop("checked", "checked")
      )
    if type is "brand"
      $.each(idArray, (index, item)->
        selectId = item + ""
        $("input[name='brandNames']").each ->
          brandId = $(@).attr("data-id") + ""
          if brandId is selectId
            $(@).prop("checked", "checked")
      )
    if type is "vendor"
      $.each(idArray, (index, item)->
        selectId = item + ""
        $("input[name='vendorName']").each ->
          vendorId = $(@).data("id") + ""
          if vendorId is selectId
            $(@).prop("checked", "checked")
      )

  #opt当前选择页面数据存储
  optCodeChange:()->
    code = $(@).data("id") + ""
    name = $(@).val()
    type = $(@)[0].checked
    optcode = $(".optCodes").data("optcodes")
    optname = $(".optCodes").data("optnames")
    idArray = []
    nameArray = []
    if optname.indexOf("、") isnt -1
      nameArray = optname.split("、")
    else if optname != ""
      nameArray.push(optname)
    placesname = $.inArray(name,nameArray)
    if type is true
      if placesname == -1
        nameArray.push(name)
    if type is false
      if placesname != -1
        nameArray.splice(placesname,1)
    optname = nameArray.join("、")
    $(".optCodes").data("optnames",optname)
    $(".optCodes").html(optname)
    $(".optCodes").attr("title",optname)
    if optcode.indexOf("、") isnt -1
      idArray = optcode.split("、")
    else if optcode != ""
      idArray.push(optcode)
    places = $.inArray(code,idArray)
    if type is true
      if places == -1
        idArray.push(code)
    if type is false
      if places != -1
        idArray.splice(places,1)
    optcode = idArray.join("、")
    $(".optCodes").data("optcodes",optcode)



  saveCategory: ->
    attributes = []
    backCategoryIds = ''
    backCategoryNms = ''
    #如果是类目
    checkedNodes = treeObj.getCheckedNodes()
    catCount = 0
    $.each(checkedNodes, (index, value)->
      ##i下标，value值 ##
      if value.level == 2
        # CHANGE START BY geshuo 20160801:[测试缺陷 #19675]文字显示错误修正
        if backCategoryNms
          backCategoryNms += "、" + value.name
          backCategoryIds += "、" + value.id
        else
          backCategoryNms = value.name
          backCategoryIds = value.id
        # CHANGE END   BY geshuo 20160801
      else
        catCount++
    )
    if backCategoryNms
      $(".close").trigger('click')
      $('#backCategoryNmss').text("") #清空赋值
      $('#backCategoryNmss').append(backCategoryNms) #显示
      $('#backCategoryNmss').data("id", backCategoryIds) #显示
      $('#backCategoryNm').val(backCategoryNms) #赋值
      $('#backCategoryId').val(backCategoryIds) #赋值
    else
      # CHANGE START BY geshuo 20160811:[测试缺陷 #20509]类目选择提示文言修正
      if catCount is 0
        $(".close").trigger('click')
        $('#backCategoryNmss').text("") #清空赋值
        $('#backCategoryNmss').append(backCategoryNms) #显示
        $('#backCategoryNmss').data("id", backCategoryIds) #显示
        $('#backCategoryNm').val(backCategoryNms) #赋值
        $('#backCategoryId').val(backCategoryIds) #赋值
      else
        that.alert "body", "error", "请选择三级后台类目！"
      # CHANGE END BY geshuo 20160811

  #确定供应商名称
  saveVendorName: ->
  #取得所checked 的value
    vendorIds = $(".optCodes").data("optcodes")
    vendorNames = $(".optCodes").data("optnames")
    #模仿点击事件关闭模态框
    $(".close").trigger('click')
    #赋值给
    $('#vendorNmss').text("") #清空赋值
    $('#vendorNmss').append(vendorNames) #显示
    $('#vendorNmss').data("id", vendorIds) #用于判断是否选中
    $('#vendorNms').val(vendorNames) #赋值
    $('#vendorId').val(vendorIds)#赋值

  #确定商品名称
  saveGoodsName: ->
    #取得所checked 的value
    goodscode = $(".optCodes").data("optcodes")
    goodsname = $(".optCodes").data("optnames")
    #模仿点击事件关闭模态框
    $(".close").trigger('click')
    #赋值给
    $('#goodsNamess').text("")
    $('#goodsNamess').append(goodsname) #显示
    $('#goodsNamess').data("id",goodscode)#用于判断是否选中
    $('#goodsName').val(goodsname) #赋值
    $('#goodsId').val(goodscode)#赋值

  #确定品牌名称
  savBrandsName: ->
    brandIds = $(".optCodes").data("optcodes")
    brandNames = $(".optCodes").data("optnames")
#模仿点击事件关闭模态框
    $(".close").trigger('click')
    $('#brandNamess').text("") #清空赋值
    $('#brandNamess').append(brandNames) #显示
    $('#brandNamess').data("id", brandIds) #用于判断是否选中
    $('#brandName').val(brandNames) #赋值
    $('#brandId').val(brandIds)#赋值



  # 更新设置
  couponSaveConfirm: (evt)->
    evt.preventDefault()
    isManual = $('input[name="isManual"]:checked ').val();
    val = $("#isFirstlogin");

    isFirstLoginCheck = isManual is '0' and val.is(":checked")# 首次登录设定 有效时间校验
    if isManual is '1' or isFirstLoginCheck
      if !$("#startTimes").val()
        that.alert "body", "error", "请填写有效日期开始时间！"
        return
      if !$("#endTimes").val()
        that.alert "body", "error", "请填写有效日期结束时间！"
        return
      # 当前日期 0点
      nowDate = new Date()
      startDate = new Date($("#startTimes").val())
      endDate = new Date($("#endTimes").val())
      # 判断 开始日期 > 当前日期
      if startDate<nowDate
        that.alert "body", "error", "有效日期开始时间必须大于当前时间！"
        return
      # 判断 结束日期 > 开始日期
      if startDate>endDate
        that.alert "body", "error", "有效日期结束时间必须大于开始时间！"
        return

    if val.is(":checked")
      $("#isFirstlogin").val("1")
    else
      $("#isFirstlogin").val("0")
    data = $("form.coupon-add-form").serializeObject()
    id = $(".coupon-add-form").data("id")
    data.id = id
    data.isFirstlogin = $("#isFirstlogin").val()
    # data.vendorNms =$("#vendorNmss").val()
    $.ajax
      url: Store.context + "/api/admin/coupon/updateCouponInf"
      type: "POST"
      data: data
      dataType: "json"
      success: (data)->
        that.alert "body", "success", "保存成功！"
        location.href = Store.context + "/mall/coupon"

  #首次登录设定 勾选事件
  styleCheckbox: ->
    # geshuo20160807
    if $("input[type='checkbox']:checked").length is 1
      $(".disStyle").show()
    else if $("input[type='checkbox']:checked").length is 0
      $(".disStyle").hide()

  #搜索树，高亮显示并展示【模糊匹配搜索条件的节点s】
  search_ztree = (treeId, searchConditionId) ->
    searchByFlag_ztree treeId, searchConditionId, ''

  ###*
  # 搜索树，高亮显示并展示【模糊匹配搜索条件的节点s】
  # @param treeId
  # @param searchConditionId     搜索条件Id
  # @param flag                  需要高亮显示的节点标识
  ###
  searchByFlag_ztree = (treeId, searchConditionId, flag) ->
#<1>.搜索条件
    searchCondition = $('#' + searchConditionId).val()
    #<2>.得到模糊匹配搜索条件的节点数组集合
    highlightNodes = new Array
    if searchCondition != ''
      treeObj = $.fn.zTree.getZTreeObj(treeId)
      highlightNodes = treeObj.getNodesByParamFuzzy('name', searchCondition, null)
    #<3>.高亮显示并展示【指定节点s】
    highlightAndExpand_ztree treeId, highlightNodes, flag
  ###*
  # 高亮显示并展示【指定节点s】
  # @param treeId
  # @param highlightNodes 需要高亮显示的节点数组
  # @param flag           需要高亮显示的节点标识
  ###
  highlightAndExpand_ztree = (treeId, highlightNodes, flag) ->
    treeObj = $.fn.zTree.getZTreeObj(treeId)
    #<1>. 先把全部节点更新为普通样式
    treeNodes = treeObj.transformToArray(treeObj.getNodes())
    i = 0
    while i < treeNodes.length
      treeNodes[i].highlight = false
      treeObj.updateNode treeNodes[i]
      i++
    #<2>.收起树, 只展开根节点下的一级节点
    close_ztree treeId
    #<3>.把指定节点的样式更新为高亮显示，并展开
    if highlightNodes != null
      i = 0
      while i < highlightNodes.length
        if flag != null and flag != ''
          if highlightNodes[i].flag == flag
#高亮显示节点，并展开
            highlightNodes[i].highlight = true
            treeObj.updateNode highlightNodes[i]
            #高亮显示节点的父节点的父节点....直到根节点，并展示
            parentNode = highlightNodes[i].getParentNode()
            parentNodes = getParentNodes_ztree(treeId, parentNode)
            treeObj.expandNode parentNodes, true, false, true
            treeObj.expandNode parentNode, true, false, true
        else
#高亮显示节点，并展开
          highlightNodes[i].highlight = true
          treeObj.updateNode highlightNodes[i]
          #高亮显示节点的父节点的父节点....直到根节点，并展示
          parentNode = highlightNodes[i].getParentNode()
          parentNodes = getParentNodes_ztree(treeId, parentNode)
          treeObj.expandNode parentNodes, true, false, true
          treeObj.expandNode parentNode, true, false, true
        i++

  #递归得到指定节点的父节点的父节点....直到根节点
  getParentNodes_ztree = (treeId, node) ->
    if node != null
      treeObj = $.fn.zTree.getZTreeObj(treeId)
      parentNode = node.getParentNode()
      getParentNodes_ztree treeId, parentNode
    else
      node

  #设置树节点字体样式
  setFontCss_ztree = (treeId, treeNode) ->
    if treeNode.id == 0
      #根节点
      return {color:"#333", "font-weight":"bold"};
    else
      #叶子节点 父节点
      if !!treeNode.highlight
        return {color:"#ff0000", "font-weight":"bold"}
      else
        if $(".js-search-value1").val()
          return {color:"#333", "font-weight":"normal"}
        else
          return {color:"#333", "font-weight":"normal"}

  #展开树
  expand_ztree = (treeId) ->
    treeObj = $.fn.zTree.getZTreeObj(treeId)
    treeObj.expandAll true

  #收起树：只展开根节点下的一级节点
  close_ztree = (treeId) ->
    treeObj = $.fn.zTree.getZTreeObj(treeId)
    nodes = treeObj.transformToArray(treeObj.getNodes())
    nodeLength = nodes.length
    i = 0
    while i < nodeLength
      if nodes[i].id == '0'
        #根节点：展开
        treeObj.expandNode nodes[i], true, true, false
      else
        #非根节点：收起
        treeObj.expandNode nodes[i], false, true, false
      i++
module.exports = coupon_set

