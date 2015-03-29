class App.TasksView extends Backbone.View

  template: App.templates.Tasks
  childViews: []

  events:
    'submit #new_task': 'create'

  initialize: ->
    _.bindAll(this, 'render', 'renderTasks', 'renderOne', 'updateCount', 'toggleCurrent', 'removeChildViews')

    @listenTo(@collection, 'reset', @render)
    @listenTo(@collection, 'add', @renderOne)
    @listenTo(@collection, 'add change', @updateCount)
    @listenTo(Backbone, 'tasks:filter', @toggleCurrent)
    @listenTo(Backbone, 'tasks:filter', @renderTasks)

  render: ->
    @$el.html(@template())
    @renderTasks()
    @updateCount()
    @toggleCurrent()
    return this

  renderTasks: ->
    @removeChildViews()
    @collection.where({aasm_state: App.filter}).reverse().forEach((task) =>
      @listenTo(task, 'change:aasm_state', @updateCount)
      @renderOne(task)
    )

  renderOne: (task) ->
    childView = new App.TaskView(model: task)
    @childViews.push(childView)
    @$('#tasks').prepend(childView.render().el)

  create: (e) ->
    e.preventDefault()

    task = new App.Task(title: $('#task_title').val())
    if task.isValid()
      task.save().done( =>
        @collection.add(task)
        Backbone.history.navigate('/tasks', true)
        Backbone.trigger('flash:show', {msg: '作成しました。'})
      )
      $('#task_title').val('')

    return false

  updateCount: ->
    @$('.inbox-count').html(@collection.inboxes().length)
    @$('.completed-count').html(@collection.completed().length)
    @$('.deleted-count').html(@collection.deleted().length)
    
  toggleCurrent: ->
    @$('#menu-inbox').toggleClass('current', App.filter == 'inbox')
    @$('#menu-completed').toggleClass('current', App.filter == 'completed')
    @$('#menu-deleted').toggleClass('current', App.filter == 'deleted')

  remove: ->
    @removeChildViews()
    super()

  removeChildViews: ->
    _.invoke(@childViews, 'remove')
    @childViews = []
