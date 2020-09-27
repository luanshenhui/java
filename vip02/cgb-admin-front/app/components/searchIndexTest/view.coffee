Store = require "extras/store"

class SearchIndexTest
  constructor: ->
    @testCreateIndexButton = $('.test-create_index')
    @testCreateIndexButton.on 'click',@testCreateIndex

  testCreateIndex:->
    $.ajax
      url: Store.context + "/api/admin/SearchIndexTest/fullItemIndex"
      type: "POST"
      success: (data)->
        alert "创建成功！"

module.exports = SearchIndexTest
