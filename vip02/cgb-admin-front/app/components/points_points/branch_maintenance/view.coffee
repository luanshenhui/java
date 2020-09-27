Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
tipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"

class BranchMaintenance
  _.extend @::, tipAndAlert
  new Pagination(".pagination").total($(".pagination").data("total")).show();
  constructor: ->
    @bindEvent()
  that = this
  branchTemplate = App.templates['branch_add_edit']
  bindEvent:->
    that = this
    $(".js-branch-new").on "click",@addBranch
    $(".js-branch-edit").on "click",@editBranch
    $(document).on "confirm:delete-branch",@deleteBranch
    $(document).on "confirm:delete-all",@deleteAll
    $(".js-all-check").on "click",@checkAll
    $("#deleteBtn").on "click", @deleteCheck

  toAdd:->
    if !that.checkInput()
      return
    $.ajax
      url: Store.context + "/api/admin/branchMaintenance/add"
      type: "POST"
      data: $("form.branch-form").serialize()
      success: (data)->
        window.location.reload()

  checkInput:->
    #添加校验
    if !$('#code').val()
      that.alert "body", "error", "添加失败", "请输入分行号！"
      return false;
    else if $('#code').val().length > 20
      that.alert "body", "error", "添加失败", "分行号不能超过20位！"
      return false;

    if !$('#name').val()
      that.alert "body", "error", "添加失败", "请输入分行名称！"
      return false;
    else if $('#name').val().length > 30
      that.alert "body", "error", "添加失败", "分行名称不能超过30个字！"
      return false;

    if !$('#bankCityNm').val()
      that.alert "body", "error", "添加失败", "请输入发卡城市！"
      return false;
    else if $('#bankCityNm').val().length > 30
      that.alert "body", "error", "添加失败", "发卡城市不能超过30个字！"
      return false;
    return true;

  toEdit:->
    if !that.checkInput()
      return;
    $.ajax
      url: Store.context + "/api/admin/branchMaintenance/update"
      type: "POST"
      data: $("form.branch-form").serialize()
      success: (data)->
        window.location.reload()

  addBranch:->
    addModal = new Modal branchTemplate({})
    addModal.show()

    $(".branch-form").validator
      isErrorOnParent: true
    $(".branch-form").on "submit",that.newConfirm

  newConfirm: (event)->
    event.preventDefault()
    $(".branch-form").validator
      isErrorOnParent: true
    that.toAdd()

  editBranch:->
    thisBranch = $(@).closest("tr").data("data")
    editModal = new Modal branchTemplate(thisBranch)
    editModal.show()

    $(".branch-form").validator
      isErrorOnParent: true
    $(document).on "submit",".branch-form",that.updateConfirm

  updateConfirm: (event)->
    event.preventDefault()
    $(".branch-form").validator
      isErrorOnParent: true
    that.toEdit()


  deleteEvent=(id)->
    $.ajax
      url: Store.context + "/api/admin/branchMaintenance/deleteBatch"
      type: "POST"
      data:{"id":id}
      success: (data)->
        window.location.reload()

  #删除分行
  deleteBranch: (event,data) ->
    event.preventDefault()
    deleteEvent(data)

  checkAll:->
    if $(".js-all-check").is(':checked')
      $(".js_checkbox_item").prop("checked",'checked')
    else
      $(".js_checkbox_item").prop("checked",'')

  #批量删除分行
  deleteAll: ->
    id = []
    _.each $(".js_checkbox_item:checked"), (checkbox)->
      id.push $(checkbox).closest(".item-tr").data("id")
    deleteEvent(id.join(","))

  #删除确认
  deleteCheck: ->
    if $(".js_checkbox_item:checked").length is 0
      that.alert "body", "error", "删除失败", "请至少选择一条数据！"
    else
      $("#deleteConfirmBtn").click()


module.exports = BranchMaintenance