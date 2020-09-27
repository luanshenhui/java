Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"
TipAndAlert = require "tip_and_alert/tip_and_alert"

bindBoardResultTemplate = App.templates["bindBoard"]
platinumCardTemplate = App.templates['platinum_card_add_edit']
temp = App.templates['bindBoard']
bindNewTemplate = App.templates['bind_new']
class PlatinumCardMaintenance
  _.extend @::, TipAndAlert
  thisCard = null
  deleteId = null
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
    @bindEvent()
    @addBtnInit()
    @checkAllBtn = ".js-all-check"
    @checkItemBtn = ".js-check-this"
    @unBindTrBtn = ".js-table-unbind"
  that = this
  proCode = null
  formatId = null
  bindEvent: ->
    that = this
    $(".js-card-new").on "click", @addPlatinumCard
    $(".js-card-edit").on "click", @editPlatinumCard
    $(document).on "confirm:delete-card", @deleteConfirm #删除
    $(document).on "confirm:unbind-card", @unbindConfirm #解除绑定
    $(".js-bind-Board").on "click", @findBindBoard
    $(".js-table-info").on "click", @tableClick
    $(".js-table-info").first().click()

#全选
  checkAll: (evt) ->
    if $(@).is(':checked')
      $("input[name='checkBind']").prop("checked", 'checked')
    else
      $("input[name='checkBind']").prop("checked", '')
#反向全选
  checkRate: (evt)->
    if $("input[name='checkBind']:checked")
      item = $("input[name='checkBind']:checked").length
      all = $("input[name='checkBind']").length
      if(item == all)
        $("input[name='checkAll']").prop("checked", 'checked')
      else
        $("input[name='checkAll']").prop("checked", '')
#新增按钮校验
  addBtnInit: (evt)->
    if $(".js-table-info").length >= 2
      $(".js-card-new").attr("disabled", true)
      $(".js-card-new").removeClass("btn-info")
    else
      $(".js-card-new").attr("disabled", false)
      $(".js-card-new").addClass("btn-info")
  addPlatinumCard: ->
    addModal = new Modal platinumCardTemplate({title: "新增"})
    addModal.show()
    $(".card-form").validator
      isErrorOnParent: true
    $("form.card-form").on "submit", that.platinumAddConfirm
  #新增
  platinumAddConfirm: (event)->
    event.preventDefault()
    data = $("form.card-form").serialize()
    $(".proNm-required-error").remove()
    $(".proCode-required-error").remove()
    $(".check-required-error").remove()
    proCodeCheck = $(".js-proCode-check").val()
    $(".card-form").validator
      isErrorOnParent: true
    if !/^[1-2]{1,1}$/.test proCodeCheck
      $("#proCode").parent().append("<span class=\"check-required-error required\"><i>&times;</i>编码等级只能为‘1’或‘2’</span>")
      return
    $.ajax
      url: Store.context + "/api/admin/localProcode/checkLocalProCode"
      type: "POST"
      data: data
      success: (data)->
        if data.data.proNmCheck == false
          that.alert "body", "error", "白金卡等级名称已存在！"
          return
        if data.data.proCodeCheck == false
          that.alert "body", "error", "白金卡等级编码已存在！"
          return
        $.ajax
          url: Store.context + "/api/admin/localProcode/add"
          type: "POST"
          data: $("form.card-form").serialize()
          success: (data)->
            that.alert "body","success","保存成功！"
            window.location.reload()

  editPlatinumCard: ->
    if thisCard is null
      that.alert "body", "error", "请至少选择一个您要编辑的白金卡等级！"
      return
    editModal = new Modal platinumCardTemplate({title: "编辑", data: thisCard})
    editModal.show()
    $("form.card-form").validator()
    $("form.card-form").on "submit", that.editConfirm
#编辑
  editConfirm: (event)->
    event.preventDefault()
    $("form.card-form").validator
      isErrorOnParent: true
    $(".proNm-required-error").remove()
    $(".proCode-required-error").remove()
    id = $("#proCode").data("id")
    $.ajax
      url: Store.context + "/api/admin/localProcode/checkLocalProCode"
      type: "POST"
      data: $("form.card-form").serialize()
      success: (data)->
        if data.data.proNmCheck == false
          that.alert "body", "error", "白金卡等级名称已存在！"
          return
        if data.data.proCodeCheck == false
          that.alert "body", "error", "白金卡等级编码已存在！"
          return
        $.ajax
          url: Store.context + "/api/admin/localProcode/edit/" + id
          type: "POST"
          data: $("form.card-form").serialize()
          success: (data)->
            that.alert "body","success","更新成功！"
            window.location.reload()

  #点击绑定按钮初始化数据
  findBindBoard: ->
    proCode = proCode
    if proCode is null
      that.alert "body", "error", "请至少选择一个您要绑定的白金卡等级！"
      return
    $.ajax
      url: Store.context + "/api/admin/localProcode/findAllCardPro"
      type: "GET"
      success: (data)->
        result = temp(data)
        $(".js-platinum-card").append(result)
        bindNewModal = new Modal bindNewTemplate(data)
        bindNewModal.show()
        $(".js-bind-card").on "click", that.checkAllBtn, that.checkAll
        $(".js-bind-card").on "click", that.checkItemBtn, that.checkRate
        $("form.bind-form").on "submit", that.bindNewCard
  #绑定操作
  bindNewCard:(event) ->
    event.preventDefault();
    proCode = proCode
    array = []
    $("input[type='checkbox']:checked").each((index, item)->
      id = $(item).data("id")
      if id 
        array.push(id)
    )
    if(array.length == 0)
      that.alert "body", "error", "请至少选择一个您要绑定的卡板！"
      return false
    $.ajax
      url: Store.context + "/api/admin/localCardRelate/bind"
      type: "POST"
      data: {array: array, proCode: proCode}
      dataType:"json"
      success: (data)->
        that.alert "body","success","绑定成功！"
        window.location.reload()
  #点击选中事件  供查询卡类卡板使用
  tableClick: (evt) ->
    proCode = $(@).data("id")
    thisCard = $(@).closest("tr").data("data")
    deleteId = thisCard.id
    $("tr").removeAttr("style")
    $(@).css("background-color", "#ffeced")
    $.ajax
      url: Store.context + "/api/admin/localProcode/" + proCode
      type: "GET"
      data: proCode
      success: (data)->
        if data is ""
          $(".js-btn").attr("disabled", false)
          $(".js-btn").addClass("btn-info")
          $(".js-card-pro").html(bindBoardResultTemplate({}))
        else
          $(".js-card-pro").html(bindBoardResultTemplate({list: data.data.data}))
          $(".js-btn").attr("disabled", true)
          $(".js-btn").removeClass("btn-info")
          $(".js-card-pro").on "click", that.unBindTrBtn, that.unbindClick

  unbindClick: (evt) ->
    formatId = $(@).data("id")
    $(".js-table-unbind").removeAttr("style")
    $(@).css("background-color", "#ffeced")
#删除操作
  deleteConfirm: (evt, data)->
    evt.preventDefault()
    if deleteId is null
      that.alert "body", "error", "请至少选择一个您要删除的白金卡等级！"
      return
    $.ajax
      url: Store.context + "/api/admin/localProcode/detele/" + deleteId
      type: "POST"
      success: (data)->
        that.alert "body","success","删除成功！"
        window.location.reload()

#解绑操作
  unbindConfirm: (evt)->
    proCode = proCode
    formatId = formatId
    $("tr").removeAttr("style")
    $(@).css("background-color", "#ffeced")
    if proCode is null
      that.alert "body", "error", "请选择您要解绑的白金卡等级！"
      return
    if formatId is null
      that.alert "body", "error", "请选择您要解绑的卡板！"
      return
    $.ajax
      url: Store.context + "/api/admin/localCardRelate/unBind"
      type: "POST"
      data: {proCode: proCode, formatId: formatId}
      success: (data)->
        that.alert "body","success","解绑成功！"
        window.location.reload()


module.exports = PlatinumCardMaintenance