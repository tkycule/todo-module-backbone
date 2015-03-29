class App.TaskView extends Backbone.View

  tagName: 'li'
  className: 'task clearfix'
  template: App.templates.Task

  initialize: ->
    @listenTo(@model, 'sync', @render)

  events:
    'click .task-actions a': 'taskAction'

  render: ->
    @$el.html(@template(_.extend(@model.toJSON(), {
      showComplete: @model.get("aasm_state") == "inbox"
      showDelete: @model.get("aasm_state") != "deleted"
      showRevert: @model.get("aasm_state") != "inbox"
    })))
    return this

  flashMessages:
    complete: '完了にしました。'
    delete: 'ゴミ箱に入れました。'
    revert: '収集箱に戻しました。'

  taskAction: (event) ->
    action = $(event.currentTarget).data('action')
    @model[action]( =>
      this.remove()
      Backbone.trigger('flash:show', {msg: @flashMessages[action]})
    )
