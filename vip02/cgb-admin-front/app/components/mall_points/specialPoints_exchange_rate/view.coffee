Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"

class SpecialPoints
  _.extend @::, TipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show();
  constructor: ->
    @checkThisRate = ".js-check-this" #列表页每一行前面的checkbox
    @allSpecial = ".js-special-delete" #全选后操作
    @selectCategory = ".js-category-select" #选择类别
    @searchBtn = ".js-search-btn"
    @scale = "#scale" #积分比例
    @bindEvent()
  specialTemplate = App.templates["specialPoints_add_edit"]
  categoryGoodsResultTemplate = App.templates["category_select_goods_result"]
  categoryBrandsResultTemplate = App.templates["category_select_brands_result"]
  categoryVendorsResultTemplate = App.templates["category_select_vendors_result"]
  categoryResultTemplate = App.templates["category_select_category_result"]
  that = this
  bindEvent: ->
    that = this
    $(".js-special-new").on "click", @addRate
    $(".js-special-edit").on "click", @editRate
    $(document).on "confirm:delete-special-points", @deleteConfirm
    $(".js-all-check").on "click", @checkAll
    $(".special-points").on "click", @checkThisRate, @checkRate #反向全选事件
    #$(".special-points").on "click", @allSpecial, @allSpecialPoints #全选后操作事件
    $(document).on "change", @selectCategory, ->
      that.categorySelect(0) #全选后操作事件
    $(document).on "click", @searchBtn, ->
      that.categorySelect(1)
    # ADD START BY geshuo 20160725:测试缺陷 #19754,添加删除确认对话框
    $(document).on "confirm:all-special-points", @allSpecialPoints
    # ADD END   BY geshuo 20160725:测试缺陷 #19754
    $(document).on "keyup", ('#scale'), @changeScale


  treeObj = null
  addRate: ->
    addModal = new Modal specialTemplate({})
    addModal.show()
    type = '0'
    searchKey = ""
    $.ajax
      url: Store.context + "/api/admin/specialPointsRate/add-findClassifications"
      type: "POST"
      data: type: type,searchKey: searchKey
      success: (data)->
        $(".js-select-result").html(categoryVendorsResultTemplate({list: data.data.result.vendorInfoModelList}))
        $("form.specialPoints-form").validator
          isErrorOnParent: true
        $("form.specialPoints-form").on "submit", that.createSpecial

  #新增
  createSpecial: (evt)->
    evt.preventDefault()
    $("form.specialPoints-form").validator
      isErrorOnParent: true
    $(".scale-required-error").remove() #最高支付比例
    data = $("form.specialPoints-form").serializeObject()
    #checkbox 拼json串
    ###获取节点集合###
    attributes=[]
    #如果是类目
    if data.type is '2'
      checkedNodes = treeObj.getCheckedNodes()
      $.each(checkedNodes,(i, value)->
        items = {}
        ##i下标，value值 ##
        if value.level == 2
          node = value.getParentNode()
          nodes = node.getParentNode()
          items.typeId = nodes.id + ">" + node.id + ">" + value.id
          items.typeVal = nodes.name + ">" + node.name + ">" + value.name
          attributes.push(items)
      )
#      nodes = checkedNodes[1].getParentNode()
#      node = checkedNodes[2].getParentNode()

#      attribute = _.map(checkedNodes, (item)->
#        items = {}
#        items.typeId = item.id
#        items.typeVal = item.name
#        attributes.push(items)
#      )
    #如果是其他
    else
      typeValue = $(".js-category-select").val()
      #定义flag为checkBox是否选中表示
      flag = false
      $("input[type='checkbox']input[name=checkbox" + typeValue + "]:checked").each((index, item)->
        flag = true
        name = $(item).data("value")
        attributes.push({"typeId": $(item).attr("id"), "typeVal": name})
      )
      if flag is false
        new Modal(
          icon: "error"
          title: "温馨提示"
          content: "请至少选择一个"
          overlay: false)
        .show()
        return
    #校验
    numval = Number(data.scale)
    slId = $.trim(data.scale)
    if isNaN(numval) || numval<0 || numval>1 || slId == "" #最高支付比例
      $("#scale").parent().append("<span class=\"scale-required-error required\"><i>&times;</i>请输入1或小于1的两位小数</span>")
      return

    attributesJson = {
      specialPointScaleModelList: attributes
    }
    typeVal = JSON.stringify attributesJson
    data.typeVal = typeVal
    if data.scale>=1 and $("#displayFlag").is(":checked")
      data.displayFlag = 1
    else
      data.displayFlag = 0
    $.ajax
      url: Store.context + "/api/admin/specialPointsRate/add"
      type: "POST"
      data: data
      success: (data)->
        that.alert "body", "success", "保存成功！"
        window.location.reload()

  editRate: ->
    thisRate = $(@).closest("tr").data("data")
    id = $(@).closest("tr").data("id")
    new Modal(specialTemplate({title: "edit", data: thisRate})).show()
    $("form.specialPoints-form").validator
      isErrorOnParent: true
    $("form.specialPoints-form").on "submit", that.rateUpdate

  rateUpdate: (evt) ->
    id = $("#id").val()
    evt.preventDefault()
    $("form.specialPoints-form").validator
      isErrorOnParent: true
    $(".scale-required-error").remove() #最高支付比例
    data = $("form.specialPoints-form").serializeObject()
    data.id = id
    #校验

    #CHANGE START BY geshuo 20160725:测试缺陷 #19757,和新增的正则校验保持一致 ，并修改提示文言
#    if !/^00?\.(?:0[1-9]|[1-9][0-9]?)$/.test data.scale #最高支付比例
    if !/^1(\.0(0){0,1}){0,1}$|^(0\.[0-9]{1,2})$/.test data.scale #最高支付比例
      $("#scale").parent().append("<span class=\"scale-required-error required\"><i>&times;</i>请输入1或小于1的两位小数</span>")
      return
    #CHANGE END   BY geshuo 20160725:测试缺陷 #19757
    if data.scale>=1 and $("#displayFlag").is(":checked")
      data.displayFlag = 1
    else
      data.displayFlag = 0
    $.ajax
      url: Store.context + "/api/admin/specialPointsRate/edit"
      type: "POST"
      data: data
      success: (data)->
        that.alert "body", "success", "更新成功！"
        window.location.reload()

  checkAll: ->
    if $(".js-all-check").is(':checked')
      $("input[name='checkRate']").prop("checked", 'checked')
    else
      $("input[name='checkRate']").prop("checked", '')

  #反向全选
  checkRate: (evt)->
    if $("input[name='checkRate']:checked")
      item = $("input[name='checkRate']:checked").length;
      all = $("input[name='checkRate']").length;
      if(item == all)
        $("input[name='checkAll']").prop("checked", 'checked')
      else
        $("input[name='checkAll']").prop("checked", '')



  deleteConfirm: (evt, data)->
    evt.preventDefault()
    $.ajax
      url: Store.context + "/api/admin/specialPointsRate/delete/" + data
      type: "POST"
      success: (data)->
        that.alert "body", "success", "删除成功！"
        window.location.reload()


  allSpecialPoints: (evt)->
    evt.preventDefault()
    array = []
    $("input[type='checkbox']:checked").each((index, item)->
      id = $(item).data("id")
      array.push(id)
    )
    if(array.length == 0)
      that.alert "body", "error", "请至少选择一条记录！"
      return false
    $.ajax
      url: Store.context + "/api/admin/specialPointsRate/deleteAllSpecialPoint"
      type: "POST"
      data:
        array: array
      success: (data)->
        that.alert "body", "success", "删除成功！"
        window.location.reload()

  categorySelect: (type)->
    that.changeScale()
    classifications = $("#special-type").find("option:selected").val()
    if(type == 0) #修改类别
     $(".js-search-value1").val("")
    else #搜索
      searchKey = $(".js-search-value1").val()
      if searchKey is undefined
        searchKey = ""
      if classifications is '2' and searchKey
        #Ztree模糊搜索
        search_ztree("treeResource","searchKey")
        return
    $.ajax
      url: Store.context + "/api/admin/specialPointsRate/add-findClassifications"
      type: "POST"
      dataType: "JSON"
      data: "type": classifications, searchKey: searchKey
      success: (data)->
        #供应商
        if classifications is '0'
          $(".js-select-result").html(categoryVendorsResultTemplate({searchKey :searchKey,list: data.data.result.vendorInfoModelList}))
        #品牌
        if classifications is '1'
          $(".js-select-result").html(categoryBrandsResultTemplate({searchKey :searchKey,list: data.data.result.goodsBrandModelList}))
        #类目
        if classifications is '2'
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
          $(".js-select-result").html(categoryResultTemplate(data.treeObj,searchKey :searchKey))
          treeObj = $.fn.zTree.init($("#treeResource"), setting, treeData)
        #商品
        if classifications is '3'
          $(".js-select-result").html(categoryGoodsResultTemplate({searchKey :searchKey,list: data.data.result.goodsModelList}))
        # ADD START BY geshuo 20160725:测试缺陷 #19758,保留查询条件
        $(".js-search-value1").val(searchKey)
        # ADD END   BY geshuo 20160725:测试缺陷 #19758

  #展开树
  expand_ztree = (treeId) ->
    treeObj = $.fn.zTree.getZTreeObj(treeId)
    treeObj.expandAll true
    return

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
    return

  #搜索树，高亮显示并展示【模糊匹配搜索条件的节点s】
  search_ztree = (treeId, searchConditionId) ->
    searchByFlag_ztree treeId, searchConditionId, ''
    return

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
    return
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
    return

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

  #修改积分支付比例 keyup事件
  changeScale:->
    if $("#scale").val()
      classifications = $("#special-type").find("option:selected").val()
      if !classifications
        classifications = $("#scale").data("type") + ""
      if classifications is '3'
        valueFloat = $("#scale").val()
        if parseFloat(valueFloat) >= 1
          $("#only-tr").removeClass("display-none") # 等于1时显示
        else if !$("#only-tr").hasClass("display-none")
          $("#only-tr").addClass("display-none")
      else
        $("#only-tr").addClass("display-none") # 不是商品时隐藏

module.exports = SpecialPoints