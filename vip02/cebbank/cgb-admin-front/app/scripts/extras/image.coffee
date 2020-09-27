imageSelectorDialogContent= """
  <ul class="image-selector-list">
  </ul>
  <div class="popup-dialog-extra">
    <span class="js-btn-upload">
      <div class="btn btn-success btn-upload btn-medium">
        <span>上传文件</span>
        <input type="file" name="file" id="js-image-upload" multiple>
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
        $imageList.spin()
        $.ajax
          url: "/api/images/user?size=15&p=#{pageNo}"
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
                $imageList.append("<li data-url=\"#{@url}\"><img src=\"#{@url}\"/><button class=\"btn btn-mini btn-trash\" data-id=\"#{@id}\"><i class=\"icon-del11x13\"></button></li>")
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
              url: "/api/images/#{$(@).data('id')}"
              type: "DELETE"
              success: ->
                refreshList()



      $("#js-image-upload", $floatDialog).fileupload
        url: "/api/images/upload"
        dataType: "text"
        start: ->
          $(".js-btn-upload", $floatDialog).addClass("disabled")
          $(".btn-upload").spin("medium")
        done: ->
          refreshList(1)
        always: ->
          $(".js-btn-upload", $floatDialog).removeClass("disabled", false)
          $(".btn-upload").spin(false)

      $(".js-btn-ok", $floatDialog).off("click").click ->
        if $(".selected", $floatDialog).length == 0
          popup.alert rootStyle, "warn", "请先点击并选中一个图片"
          return
        popup.close()
        deferred.resolve $(".selected", $floatDialog).data("url")
