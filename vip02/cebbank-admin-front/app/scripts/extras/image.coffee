Store = require "extras/store"
imageSelectorDialogContent = """
  <ul class="image-selector-list">
  </ul>
  <div class="popup-dialog-extra">
    <span class="js-btn-upload">
      <div class="btn btn-upload btn-small image-buttons">
        <label>
          <span class="upload-span">上传文件</span>
          <input type="file" name="file" id="js-image-upload" multiple>
        </label>
      </div>
    </span>
    <div class="pagination" id="js-list-pagination" style="float: right;"></div>
  </div>
"""

module.exports =
  selector: (rootStyle) ->
    Modal = require "spirit/components/modal"
    popup = require "extras/popup"
    config =
      rootStyle: rootStyle
      title: "选择图片"
      content: imageSelectorDialogContent
    popup.show config, ($floatDialog, deferred) ->
      $imageList = $(".image-selector-list", $floatDialog)
      refreshList = (pageNo) ->
        pageNo = $imageList.data("pageNo") unless pageNo
        $.ajax
          url: Store.context + "/api/images/user?size=15&p=#{pageNo}"
          type: "GET"
          cache: false
          success: (response) ->
            $imageList.spin(false).data("pageNo", pageNo)
            $("#js-list-pagination").pagination response.data.total,
              num_display_entries: 3
              num_edge_entries: 1
              current_page: pageNo - 1
              prev_text: "上一页"
              next_text: "下一页"
              items_per_page: 15
              link_to: "javascript:void(0)"
              load_first_page: false
              callback: (pageId) ->
                refreshList(pageId + 1)
            $imageList.empty()
            if response.data.data
              $.each response.data.data, ->
                $imageList.append("<li data-url=\"#{@url}\"><img src=\"#{@url}\"/><button class=\"btn btn-mini btn-trash\" data-id=\"#{@id}\"><i class=\"fa fa-fw fa-trash-o\"></button></li>")
              $("li:first", $imageList).click()


      refreshList(1)

      $imageList.on
        click: ->
          $(this).addClass("selected").siblings().removeClass("selected")
        mouseenter: ->
          $(this).addClass("hover")
        mouseleave: ->
          $(this).removeClass("hover")
      , "li"

      $imageList.on "click", ".btn-trash", (evt) ->
        evt.stopPropagation()
        # confirmDelete = new Modal
        #   "icon": "confirm"
        #   "title": "确认删除"
        #   "content": "删除之后图片将不存在，若还需要请再次上传"
        #   "event": "confirm:deleteImage"
        # confirmDelete.show()
        popup.confirm(rootStyle, "icons-confirm", "确认删除吗？")
        .done =>
          $.ajax
            url: Store.context + "/api/images/#{$(@).data('id')}"
            type: "DELETE"
            success: ->
              refreshList()
              $imageList.spin(false)

      $("#js-image-upload", $floatDialog).fileupload
        url: Store.context + "/api/images/upload"
        dataType: "text"
        start: ->
          $(".js-btn-upload", $floatDialog).addClass("disabled")
          $(".btn-upload").spin("medium")
        done: ->
          refreshList(1)
        always: ->
          $(".js-btn-upload", $floatDialog).removeClass("disabled", false)
          $(".btn-upload").spin(false)
        error:(data)->
          responseText = ""
          if data.status is 413 then responseText = "上传的文件超过规定大小" else responseText = data.responseText
          popup.alert rootStyle, "warn", responseText

      $(".js-btn-ok", $floatDialog).off("click").click ->
        if $(".selected", $floatDialog).length == 0
          popup.alert rootStyle, "warn", "请先点击并选中一个图片"
          return
        popup.close()
        deferred.resolve $(".selected", $floatDialog).data("url")
