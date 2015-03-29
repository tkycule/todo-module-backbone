class @App.Router extends Backbone.Router

  initialize: ->
    App.session = new App.Session()
    new App.HeaderView()
    new App.FlashView()
    
  routes:
    '': 'index'
    'logout': 'logout'
    'users/new': 'new_user'
    'tasks(/:filter)': 'tasks'
    'tasks/:id/edit': 'edit_task'

  index: ->
    @skipLogin =>
      @currentView.remove() if @currentView
      @currentView = new App.IndexView(model: App.session)
      $('#main').html(@currentView.render().el)

  logout: ->
    @requireLogin ->
      App.session.logout()
      Backbone.history.navigate('', true)
      Backbone.trigger('flash:show', {msg: 'ログアウトしました。'})

  new_user: ->
    @skipLogin =>
      @currentView.remove() if @currentView
      @currentView = new App.NewUserView()
      $('#main').html(@currentView.render().el)

  tasks: (filter) ->
    @requireLogin =>

      App.filter = filter || 'inbox'
      Backbone.trigger('tasks:filter')

      unless @tasksCollection
        @tasksCollection = new App.TasksCollection()
        @tasksCollection.fetch({reset: true})

      unless @currentView instanceof App.TasksView
        @currentView.remove() if @currentView
        @currentView = new App.TasksView(collection: @tasksCollection)
        $('#main').html(@currentView.render().el)

  edit_task: (id) ->
    @requireLogin =>
      @currentView.remove() if @currentView

      defer = []
      unless @tasksCollection
        @tasksCollection = new App.TasksCollection()
        defer = @tasksCollection.fetch({reset: true})

      $.when(defer).done =>
        @currentView = new App.EditTaskView(model: @tasksCollection.findWhere(id: parseInt(id)))
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

