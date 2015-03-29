class @App.Router extends Backbone.Router

  initialize: ->
    App.session = new App.Session()
    new App.HeaderView()
    new App.FlashView()
    

