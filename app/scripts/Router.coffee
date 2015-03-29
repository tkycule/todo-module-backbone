class @App.Router extends Backbone.Router

  initialize: ->
    App.session = new App.Session()
    new App.HeaderView()
    new App.FlashView()
    
  routes:
    '': 'index'

  index: ->
    @skipLogin =>
      @currentView.remove() if @currentView
      @currentView = new App.IndexView(model: App.session)
      $('#main').html(@currentView.render().el)
    
  skipLogin: (callback) ->
    unless App.session.currentUser()
      callback.call(this)
    else
      Backbone.history.navigate('/tasks', true)

  requireLogin: (callback) ->
    if App.session.currentUser()
      callback.call(this)
    else
      Backbone.history.navigate('/', true)

