class App.HeaderView extends Backbone.View

  el: 'header'

  initialize: ->
    @listenTo(App.session, 'change', @change)
    @change()

  change: ->
    currentUser = App.session.currentUser()

    @$('.is-login').toggle(!!currentUser)
    @$('.is-not-login').toggle(!currentUser)

    if currentUser
      @$('.email').html(currentUser.get('email'))

