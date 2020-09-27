jQuery.fn.cleanWhitespace = (deep) ->
  @contents().filter ->
    if @nodeType isnt 3
      if deep
         $(@).cleanWhitespace(deep)
      return false
    else
      @textContent = $.trim(@textContent);
      return !/\S/.test(@nodeValue)
  .remove()
  return @