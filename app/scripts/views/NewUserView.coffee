class App.NewUserView extends Backbone.View

  template: App.templates.NewUser

  initialize: ->
    @model = new App.User()
    @listenTo(@model, 'invalid', _.bind(@onInvalid, this))

  events:
    'submit form#new_user': 'submit'

  render: ->
    @$el.html @template()
    return this

  submit: (e) ->
    e.preventDefault()

    @model.set('email', @$('#user_email').val())
    @model.set('password', @$('#user_password').val())
    @model.set('password_confirmation', @$('#user_password_confirmation').val())

    @$('.form-group').removeClass('has-error').find('.help-block').html('')

    if @model.isValid()
      @model.save().done =>
        App.session.setUser(@model)
        Backbone.history.navigate('/tasks', true)

  onInvalid: (model, error) ->
    _.each(error, (value, key) ->
      @$(".form-group.user_#{key}")
        .addClass('has-error')
        .find('.help-block').html(value)
    )
