class App.EditTaskView extends Backbone.View

  template: App.templates.EditTask

  events:
    'submit': 'onSubmit'

  initialize: ->
    @listenTo(@model, 'invalid', @onInvalid)
    @render()

  render: ->
    @$el.html(@template(@model.toJSON()))
    return this

  onSubmit: (e) ->
    e.preventDefault()

    @model.set('title', @$('#task_title').val())
    @model.set('memo', @$('#task_memo').val())

    @$('.form-group').removeClass('has-error').find('.help-block').html('')

    if @model.isValid()
      @model.save().done(->
        Backbone.history.navigate('/tasks', true)
        Backbone.trigger('flash:show', {msg: '更新しました。'})
      )

    return false

  onInvalid: (model, error) ->
    _.each(error, (value, key) ->
      @$(".form-group.task_#{key}")
        .addClass('has-error')
        .find('.help-block').html(value)
    )
