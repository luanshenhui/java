tipAndAlert = require "tip_and_alert/tip_and_alert"
Pagination = require "spirit/components/pagination"
Modal = require "spirit/components/modal"
Store = require "extras/store"
#business_edit = App.templates["business_edit"]
business_edit = App.templates.business_control.templates["business_edit"]
class BusinessControl
  new Pagination(".pagination").total($(".pagination").data("total")).show()
  constructor: ->
    @jsBusinessStart = ".js-business-start"
    @jsBusinessEnd = ".js-business-end"
    @jsEditPrompt= ".js-prompt-update"
    @select1 = ".js-select1" #业务类型
    @select2 = ".js-select2" #子业务类型
    @bindEvent()
  that = this
  bindEvent: ->
    that = this
    $(@jsBusinessStart).on "click", @startBusiness
    $(@jsBusinessEnd).on "click", @endBusiness
    $(@jsEditPrompt).on "click", @editPrompt
    $(@select1).on "change", @selectChange
    $(@select2).on "change", @selectChange2

  startBusiness:(evt)->
    evt.preventDefault()
    $(".brand-form-view").validator()
    data =$(".business-form").serializeObject()
    data.parametersId = $(@).closest("tr").data("id")
    data.openCloseFlag = 0
    $.ajax
      url: Store.context + "/api/admin/business/startStop"
      type: "POST"
      data: data
      success: (data)->
        window.location.reload()

  endBusiness:(evt)->
    evt.preventDefault()
    $(".brand-form-view").validator()
    data =$(".business-form").serializeObject()
    data.parametersId = $(@).closest("tr").data("id")
    data.openCloseFlag = 1
    $.ajax
      url: Store.context + "/api/admin/business/startStop"
      type: "POST"
      data: data
      success: (data)->
        window.location.reload()

  editPrompt: (evt)->
    data = $(@).closest("tr").data("data")
    new Modal(business_edit({title: "编辑业务话术", data: data})).show()
    $("form.business-form").validator
      isErrorOnParent: true
    $("form.business-form").on "submit", that.businessFormUpdate

  businessFormUpdate: ->
    data = $("form.business-form").serializeObject()
    $.ajax
      url: Store.context + "/api/admin/business/edit"
      type: "POST"
      data: data
      success: ->
        window.location.reload()


  selectChange: ()->
    id = $(@).val()
    if id is ""
      html = ''
      html += '<option  value="dq">登录启停</option>'
      html += '<option  value="db">登录白名单</option>'
      html += '<option  value="yg">广发商城</option>'
      html += '<option  value="jf">积分商城</option>'
      $(".js-select2").html('<option  value="">请选择</option>').append(html)
      return
    if id is "0"
      html = ''
      html += '<option  value="dq">登录启停</option>'
      html += '<option  value="db">登录白名单</option>'
      $(".js-select2").html('<option  value="">请选择</option>').append(html)
      return
    if id is "2"
      html = ''
      html += '<option  value="yg">广发商城</option>'
      html += '<option  value="jf">积分商城</option>'
      $(".js-select2").html('<option  value="">请选择</option>').append(html)


  selectChange2: ()->
    id = $(@).val()
    if id is "dq"
      $(".js-select1").val("0")
      return
    if id is "db"
      $(".js-select1").val("0")
      return
    if id is "yg"
      $(".js-select1").val("2")
      return
    if id is "jf"
      $(".js-select1").val("2")
      return


module.exports = BusinessControl


