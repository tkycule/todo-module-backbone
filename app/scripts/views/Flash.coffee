class App.FlashView extends Backbone.View

  el: '.alert'

  initialize: ->
    @listenTo(Backbone, 'flash:show', @showFlash)
    @listenTo(Backbone, 'flash:hide', @hideFlash)

  showFlash: (data) ->

    data = $.extend({type: 'info'}, data)

    @$el.removeClass((index, css) ->
      return css.match(/alert-\S+/)
    ).addClass("alert-#{data.type}").show().find('p').html(data.msg)

  hideFlash: ->
    @$el.hide()
