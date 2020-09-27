Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"

class role
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
#添加
    @roleNew = ".js-role-new"
    #修改
    @roleEdit = ".js-role-edit"
    @bindEvent()
  #添加和修改公用一个页面
  newRoleTemplate = App.templates.role_manage.templates["create_role"]
  editRoleTemplate = App.templates.role_manage.templates["create_role"]
  that = null
  bindEvent: ->
    that = this
    $(@roleNew).on "click", @newRole
    $(@roleEdit).on "click", @editRole
    $(document).on "confirm:delete-role",@deleteRole

  #ztree模式数据
  treeObj = null
  tree_init: ->
    treeData = null
    $.ajax
      async: false
      url: Store.context + "/api/admin/roleMenu/getAllResource"
      type: "post"
      dataType: "json"
      success: (data)->
        treeData = data.data
    setting =
      data:
        simpleData:
          enable: true
          idKey: "id"
          pIdKey: "pid"
          rootPId: "0"
      check:
        enable: true
        autoCheckTrigger: true
    treeObj = $.fn.zTree.init($("#treeResource"), setting, treeData)

  deleteRole:(event,id)->
    $.ajax
      url: Store.context + "/api/admin/role/delete/"+id
      type: "POST"
      data:"JSON"
      success: (data)->
        window.location.reload()

  #添加操作
  newRole: ->
    new Modal(newRoleTemplate({title: "新增角色",add:true})).show()
    $(".role-form").validator
      isErrorOnParent: true
    $("form.role-form").on "submit", that.createRole
    that.tree_init()

  createRole: (evt)->
    ###获取节点集合###
    checkedNodes = treeObj.getCheckedNodes()
    formObj = $("form.role-form").serializeObject()
    ids = _.map(checkedNodes, (item)->
      return item.id
    )
    formObj.resourceIds = ids
    evt.preventDefault()
    if formObj.isEnabled is "" or formObj.isEnabled is null
      TipAndAlert.alert "body", "error", "请选择状态"
      return
    $.ajax
      url: Store.context + "/api/admin/role/add"
      type: "POST"
      contentType: "application/json;charset=utf-8"
      data: JSON.stringify(formObj)
      success: (data)->
        window.location.reload()

  editRole: ->
    ###对于编辑节点，要把当前已经分配权限的节点选中###
    currentRoleId = $(@).closest("tr").data("id")
    roleResources = null
    $.ajax
      async: false
      url: Store.context + "/api/admin/roleMenu/getRoleResource"
      type: "POST"
      dataType: "JSON"
      data:
        roleId: currentRoleId
      success: (ids)->
        roleResources = ids.data
    data = $(@).closest("tr").data("data")
    new Modal(editRoleTemplate(title: "修改角色", data: data)).show()
    $(".role-form").validator
      isErrorOnParent: true
    $("form.role-form").on "submit", that.editRoleConfirm
    that.tree_init()
    ###处理所有节点 把已经分配的权限设成选中状态###
    nodes = treeObj.transformToArray(treeObj.getNodes());
    $.each(nodes, (index, itemNode)->
      if  _.indexOf(roleResources, itemNode.id) isnt -1
        ready = treeObj.getNodeByParam("id", itemNode.id)
        treeObj.checkNode(ready, true, false)
    )
    @

  editRoleConfirm: (event)->
    event.preventDefault()
    obj = $("form.role-form").serializeObject()
    obj.roleId = $("form.role-form").data("id")
    checkedNodes = treeObj.getCheckedNodes()
    ids = _.map(checkedNodes, (item)->
      return item.id
    )
    obj.resourceIds = ids
    $.ajax
      url: Store.context + "/api/admin/role/edit"
      type: "POST"
      dataType: "JSON"
      contentType: "application/json"
      data: JSON.stringify obj
      success: (data)->
        window.location.reload()


module.exports = role
