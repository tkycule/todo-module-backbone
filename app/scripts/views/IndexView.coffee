class App.IndexView extends Backbone.View

  template: App.templates.Index

  initialize: ->
    @listenTo(@model, 'invalid', _.bind(@onInvalid))

  events:
    'submit form#new_user': 'submit'

  render: ->
    @$el.html @template()
    return this

  submit: (e) ->
    e.preventDefault()

    @model.set('email', @$('#user_email').val())
    @model.set('password', @$('#user_password').val())

    if @model.isValid()
      @model.save().done( ->
        Backbone.history.navigate('/tasks', true)
        Backbone.trigger('flash:show', {msg: 'ログインしました。'})
      ).fail( ->
        alert 'ログインに失敗しました'
      )

  onInvalid: (model, error) ->
    alert error
