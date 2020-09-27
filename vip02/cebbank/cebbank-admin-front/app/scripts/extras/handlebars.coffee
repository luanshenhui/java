Handlebars.registerHelper 'add', (a,b, options) ->
  a + b

Handlebars.registerHelper "formatPrice", (price, type, options) ->
  return if not price?
  if type is 1
    formatedPrice = (price / 100)
    roundedPrice = parseInt(price / 100)
  else
    formatedPrice = (price / 100).toFixed(2)
    roundedPrice = parseInt(price / 100).toFixed(2)
  if `formatedPrice == roundedPrice` then roundedPrice else formatedPrice

Handlebars.registerHelper "formatDate", (date, type, options) ->
  return unless date
  switch type
    when "gmt" then moment(parseInt date).format("EEE MMM dd HH:mm:ss Z yyyy")
    when "day" then moment(parseInt date).format("YYYY-MM-DD")
    when "time" then moment(parseInt date).format("HH:mm:ss")
    else moment(parseInt date).format("YYYY-MM-DD HH:mm:ss")
