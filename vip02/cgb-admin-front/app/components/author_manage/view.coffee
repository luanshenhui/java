Pagination = require "spirit/components/pagination"
Modal = require "spirit/components/modal"
Store = require "extras/store"

class AuthorManage
    authorTypeTemplate = App.templates["author_update"]
    new Pagination(".author-pagination").total($(".author-manage").data("total")).show()
    that = this

    constructor: ->
        @userTypeChange = $(".js-type-change")
        @userTypeForm = ".author-update-form"
        @userTypeSelect = ".user-type-select"
        @roleTypeSelect = ".role-type-select"
        @bindEvent()

    bindEvent: ->
        @userTypeChange.on "click", @changeUserType
        $(document).on "change", @userTypeSelect, @getRoleList
        $(document).on "submit", @userTypeForm, @updateUserType
        that = this

    changeUserType: ->
        tr = $(@).closest("tr")
        id = tr.data("id")
        name = tr.data("name")
        type = tr.data("type")
        role = tr.data("role")
        userRoleId = tr.data("userroleid")
        new Modal(authorTypeTemplate({user:{"id": id, "name": name, "type": type, "role": role, "userroleid": userRoleId}})).show()
        that.getRoleList()

    getRoleList: ->
        sele = $(that.userTypeSelect).find("option:selected")
        if sele.val() is "1"
            $(".user-role-change").hide()
            return
        else
            $(".user-role-change").show()
        value = sele.text()
        $.ajax
            url: Store.context + "/api/admin/roles"
            type: "GET"
            data: ""
            success: (data) ->
                if data.data
                    roleList = ""
                    $.each data.data, (index, el) ->
                        if el.name.indexOf(value) isnt -1
                            roleList += "<option value=\"#{el.id}\">#{el.name}</option>"
                    $(that.roleTypeSelect).html(roleList)

    updateUserType: (evt)->
        evt.preventDefault()
        data = {
            user: {
                id: $(@).data("id")
                name: $(@).data("name")
                type: $(".user-type-select").val()
            },
            role: {
                id: $(".role-type-select").val()
                name: $(".role-type-select option:selected").text()
            }
        }
        userroleid = $(@).data("userroleid")
        if !userroleid
            $.ajax
                url: Store.context + "/api/admin/userRoles"
                type: "POST"
                data: JSON.stringify(data)
                contentType: "application/json"
                success: (data)->
                    if data
                        window.location.reload()
        else
            data.userRoleId = userroleid
            $.ajax
                url: Store.context + "/api/admin/userRoles"
                type: "PUT"
                data: JSON.stringify(data)
                contentType: "application/json"
                success: (data)->
                    if data
                        window.location.reload()

module.exports = AuthorManage
