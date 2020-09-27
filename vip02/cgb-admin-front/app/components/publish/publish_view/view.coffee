Modal = require "spirit/components/modal"
Pagination = require "spirit/components/pagination"
Store = require "extras/store"

class publishView
  constructor: ->
    text = $('.js-publishContent').data('publishcontent')
    require.async(['/static/umeditor/umeditor.config.js','/static/umeditor/umeditor.min.js'], (a)->
      um = UM.getEditor('myEditor', {
        zIndex: 99
      })
      um.addListener "ready", ->
        um.setContent(text)
        um.setDisabled('fullscreen')
    )
module.exports = publishView