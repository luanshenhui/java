Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"
PartitionAdd = App.templates["gift_partition_add"]

class giftPartition
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
    @$PartitionAdd=$(".js-gift-add")#新增按钮
    @$partitionEdit=$(".js-partition-edit")#编辑按钮
    @onStatus=$(".btn-on-cur")#已启用按钮
    @offStatus=$(".btn-off-cur")#未启用按钮
    @bindEvent()
  that=this

  bindEvent: ->
    that = this
    @$PartitionAdd.on "click", @newPartition #点击新增
    @$partitionEdit.on "click",@editPartition #点击编辑按钮
    $(document).on "confirm:delete-partition", @deletePartition #点击删除按钮
    @onStatus.on "click",@changePartitionStatus #点击已启用图标，切换状态为未启用
    @offStatus.on "click",@changePartitionStatus #点击未启用图标，切换状态为已启用

  #新增礼品分区
  newPartition: (evt)->
    partitionAdd = new Modal PartitionAdd({title: "新增礼品分区"})
    partitionAdd.show()
    that.selectedList()
    $("form.gift_partition-form-add").validator
      isErrorOnParent: true
    $("form.gift_partition-form-add").on "submit", that.savePartition

  #获取所有积分类型名称
  selectedList: (evt)->
    data = $(@).closest("tr").data("data")
    $.ajax
      url: Store.context + "/api/admin/giftPartition/findPointsTypeName"
      type: "POST"
      success: (data)->
        html = ''
        $.each(data.data, (index, item)->
          html += '<option  value=' + item.integraltypeId + '>' + item.integraltypeNm + '</option>'
        )
        $(".js-point-type-selected").html('<option  value="">请选择</option>').append(html)
        that.initSelected()

#新增礼品分区确认按钮
  savePartition: (evt)->
    evt.preventDefault()
    $("form.gift_partition-form-add").validator
      isErrorOnParent: true
    $(".termName-required-error").remove()
    # 唯一性校验
    areaName = $(".js-partition-name").val()
    areaId = $(".js-partition-code").val()
    id = $(".js-partition-code").data("espAreaInfModel.id")
    areaSeq = $(".js-partition-sort").val()
    formatId = $(".js-formatCode").val()
    areaDesc= $("#areaDesc").val()
    data =$(".gift_partition-form-add").serializeObject()
    if areaName != ""
      data = {}
      data.areaName = areaName
      data.areaId = areaId
      data.areaSeq = areaSeq
      data.id=id
#      if !areaIdCheck(areaId)
#        $("#code").parent().append("<span class=\"termName-required-error required\"><i>&times;</i>分区代码只能为数字或字母</span>")
#        return
#      if !illegalChar(name)
#        $("#name").parent().append("<span class=\"termName-required-error required\"><i>&times;</i>分区名称不允许包含特殊字符！</span>")
#        return
#      if !areaSeqCheck(areaSeq)
#        $("#sort").parent().append("<span class=\"termName-required-error required\"><i>&times;</i>请输入正整数</span>")
#        return
      if !formatIdTextArea(formatId)
        $("#formatId").parent().append("<span class=\"termName-required-error required\"><i>&times;</i>第三级卡产品编码不可超过2000个字符！</span>")
        return
      if !areaDescTextArea(areaDesc)
        $("#areaDesc").parent().append("<span class=\"termName-required-error required\"><i>&times;</i>分区描述不可超过150个字符！</span>")
        return
      $.ajax
        url: Store.context + "/api/admin/giftPartition/checkGiftPartition"
        type: "POST"
        data: data
        success: (data)->
          if data.data.codeCheck == false
            $("#areaId").parent().append("<span class=\"termName-required-error required\"><i>&times;</i> 分区代码已存在</span>")
            return
          if data.data.nameCheck == false
            $("#areaName").parent().append("<span class=\"termName-required-error required\"><i>&times;</i> 分区名称已存在</span>")
            return
          if data.data.sortCheck == false
            $("#areaSeq").parent().append("<span class=\"termName-required-error required\"><i>&times;</i> 显示顺序已存在</span>")
            return
          $.ajax
            url: Store.context + "/api/admin/giftPartition/create"
            type: "POST"
            data: $("form.gift_partition-form-add").serializeObject()
            success: (data)->
              window.location.reload()
            error: (data) ->
              new Modal(
                icon: "error"
                title: "出错啦！"
                content: data.responseText || "未知故障"
                overlay: false)
              .show()

  #编辑礼品分区
  editPartition: (evt)->
    data = $(@).closest("tr").data("data")
    partitionAdd = new Modal PartitionAdd({title: "编辑礼品分区",data: data})
    partitionAdd.show()
    $(".type-type").val(data.espAreaInfModel.integralType)
    that.selectedList()
    $("form.gift_partition-form-add").validator
      isErrorOnParent: true
    $("form.gift_partition-form-add").on "submit", that.updatePartition
  initSelected: ()->
    typeCode = $(".type-type").val()
    if typeCode isnt null
      $(".js-point-type-selected").val(typeCode)

  updatePartition: (evt)->
    evt.preventDefault()
    $("form.gift_partition-form-add").validator
      isErrorOnParent: true
    $(".termName-required-error").remove()
    #唯一性校验
    data = $(".gift_partition-form-add").serializeObject()
    areaName = data.areaName
    id = data.id
    areaId = data.areaId
    formatId = data.formatId
    areaDesc = data.areaDesc
    areaSeq = $(".js-partition-sort").val()
    updateData = {}
    updateData.areaSeq = areaSeq #显示顺序
    updateData.id=id #主键Id
    updateData.integralType=$(".js-point-type-selected").val() #积分类型Id
    updateData.formatId = formatId #第三級卡产品编码
    updateData.areaDesc = areaDesc #分区描述
#    if !areaSeqCheck(areaSeq)
#      $("#areaSeq").parent().append("<span class=\"termName-required-error required\"><i>&times;</i>请输入正整数</span>")
#      return
    if areaId =='00'
      updateData.areaType = '01'
    else if areaId == '01'
      updateData.areaType = '02'
    else if areaId == '04'
      updateData.areaType = '09'
    else
      updateData.areaType ='03'
    if !formatIdTextArea(formatId)
      $("#formatId").parent().append("<span class=\"termName-required-error required\"><i>&times;</i>第三级卡产品编码不可超过5000个字符！</span>")
      return
    if !areaDescTextArea(areaDesc)
      $("#areaDesc").parent().append("<span class=\"termName-required-error required\"><i>&times;</i>分区描述不可超过150个字符！</span>")
      return
    $.ajax
      url: Store.context + "/api/admin/giftPartition/checkGiftPartition"
      type: "POST"
      data: {
        areaId :areaId
        areaName:areaName
        id :id
        areaSeq :areaSeq
      }
      success: (data)->
        if data.data.sortCheck == false
          $("#areaSeq").parent().append("<span class=\"termName-required-error required\"><i>&times;</i> 显示顺序已存在</span>")
          return
        $.ajax
          url: Store.context + "/api/admin/giftPartition/updatePartition"
          type: "POST"
          data: updateData
          success: (data)->
            window.location.reload()
  #删除礼品分区
  deletePartition: (evt, data)->
    id=data
    $.ajax
      url: Store.context + "/api/admin/giftPartition/"+id
      type: "POST"
      success: (data)->
        window.location.href = Store.context + "/points/gift/gift_partition"
      error: (data) ->
        new Modal(
          icon: 'error'
          title: '出错啦！'
          content: data.responseText or '未知故障'
          overlay: false).show()
#更改分区状态操作
  changePartitionStatus: (evt)->
    data = $(@).closest("tr").data("data")
    areaId = data.espAreaInfModel.areaId
    id=data.espAreaInfModel.id

    #获取当前状态值
    curStatus = data.espAreaInfModel.curStatus
    if curStatus == '0102'
      changeStatus = '0101'
      data.curStatus = changeStatus
      data.id = id
      $.ajax
        url:Store.context + '/api/admin/giftPartition/checkUsedPartition'
        type: 'POST'
        data: areaId: areaId
        success: (Data) ->
          if Data.data.regionTypeCheck == false
            TipAndAlert.alert "body", "error", "此礼品分区下有礼品，无法停用！"
            return
          if Data.data.regionTypeCheck == true
            $.ajax
              url:Store.context + '/api/admin/giftPartition/updatePartition'
              type: 'POST'
              data: data
              success: (data) ->
                TipAndAlert.alert "body", "success", "保存成功！"
                window.location.reload()
              error: (data) ->
                new Modal(
                  icon: 'error'
                  title: '出错啦！'
                  content: data.responseText or '未知故障'
                  overlay: false).show()
    else
      changeStatus = '0102'
      data.curStatus = changeStatus
      data.id = id
      $.ajax
        url: Store.context + '/api/admin/giftPartition/updatePartition'
        type: 'POST'
        data: data
        success: (data) ->
          TipAndAlert.alert "body", "success", "保存成功！"
          window.location.reload()
        error: (data) ->
          new Modal(
            icon: 'error'
            title: '出错啦！'
            content: data.responseText or '未知故障'
            overlay: false).show()
#  #特殊字符校验
#  illegalChar = (evt) ->
#    pattern = /^([\u4e00-\u9fa5]+|[\u4e00-\u9fa5a-zA-Z_0-9]+)$/
#    if pattern.test(evt)
#      return true
#    false
#  # 分区代码校验
#  areaIdCheck = (evt) ->
#    idPattern = /^[A-Za-z0-9]+$/
#    if idPattern.test(evt)
#      return true
#    false
#  # 显示顺序校验
#  areaSeqCheck = (evt) ->
#    seqPattern = /^[1-9]\d*$/
#    if seqPattern.test(evt)
#      return true
#    false
  #textarea长度校验
  #校验第三级卡产品编码
  formatIdTextArea = (formatId)->
    if formatId isnt "" and formatId.length > 5000
      return false
    true
  #校验分区备注
  areaDescTextArea = (areaDesc)->
    if areaDesc isnt "" and areaDesc.length >150
      return false
    true
module.exports = giftPartition
