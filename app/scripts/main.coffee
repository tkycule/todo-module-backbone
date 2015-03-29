$(document).on('click', 'a[href]', (e) ->
  e.preventDefault()
  Backbone.history.navigate($(this).attr('href').substr(1), true)
)

@App = {}
