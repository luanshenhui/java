Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"

class cardPro
  new Pagination(".pagination").total($(".pagination").data("total")).show()

  constructor: ->
    @addbtn = $(".js-add-btn") # ����
    @idetLink = $(".js_idet_link") # �޸�
    @deleteAll = $(".js-delete-all") # ȫѡ
    @deleteLink = $(".js_delete_link") # ɾ��
    @checkAll = $(".check_all") # ȫѡ
    @bindEvent()
  addCardProModel = App.templates["add_card_pro"]
  that = this

  bindEvent: ->
    that = this
    @addbtn.on "click", @addBtnEvent # ����
    @idetLink.on "click", @idetLinkEvent # �޸�
    $(document).on "confirm:delete-one", @deleteLinkEvent
    $(document).on "confirm:delete-all", @deleteAllEvent
#    @deleteLink.on "click", @deleteLinkEvent # ɾ��
#    @deleteAll.on  "click", @deleteAllEvent # ����ɾ��
    @checkAll.on "click", @checkAllEvent # ȫѡ
    $(".btn-close").on "click", @closeCardProEvent

  # ����ɾ��
  deleteAllEvent: ->
    id = []
    _.each $(".js_checkbox_item:checked"), (checkbox)->
      id.push $(checkbox).closest(".item-tr").data("id")
    deleteEvent(id.join(","))

  # ɾ��
  deleteLinkEvent: (evt,data) ->
    id = data
    deleteEvent(id)

  deleteEvent= (id)->
    $.ajax
      url: Store.context + "/api/admin/CardPro/deleteCardPro"
      type: "POST"
      data: {"id": id}
      success: (data)->
        if data.data
          window.location.reload()
        else
          that.alert "body", "error", "����ʧ��", "�����³��Խ���"

  # ȫѡ��/ȫ���
  checkAllEvent: ->
    if $(@).is(':checked')
      $(".js_checkbox_item").prop("checked",true)
    else
      $(".js_checkbox_item").prop("checked",false)

  idetLinkEvent: ->
    id = $(@).closest(".item-tr").data("id")
    # ȡ��ʵʱ����
    $.ajax
      url: Store.context + "/api/admin/CardPro/findCardProById"
      type: "GET"
      data: {"id": id}
      success: (data)->
        if data.data
          addCardPro = new Modal addCardProModel(data.data)
          addCardPro.show()
        else
          that.alert "body", "error", "����ʧ��", "�����³��Խ���"
    $(".add_card_pro").validator
      isErrorOnParent: true
    $(document).on "submit", that.changeCardProEvent

  addBtnEvent: ->
    addCardPro = new Modal addCardProModel()
    addCardPro.show()
    $(".add_card_pro").validator
      isErrorOnParent: true
    $(document).on "submit", that.changeCardProEvent

  changeCardProEvent: (evt)->
    evt.preventDefault()
    $(".add_card_pro").validator
    if $("#formatId").val().length > 4
      that.alert "body", "error", "错误提示", "三级卡产品编号不能大于四位！"

    data =$(".add_card_pro").serializeObject()
    # ��ȷ��
    data.cardLevelId = "1"
    data.id = $(".add_card_pro").data("id")
    $.ajax
      url: Store.context + "/api/admin/CardPro"
      type: "POST"
      data: data
      success: (data)->
        if data.data
          window.location.reload()

module.exports = cardPro
