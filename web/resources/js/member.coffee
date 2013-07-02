jQuery ->
	HOST = 'http://bapul.cloudapp.net/rest/'

	class Question extends Backbone.Model
		urlRoot: HOST + 'question'

	class Questions extends Backbone.Collection
		url: HOST + 'questions'
		model: Question
		parse: (response) ->
			response.items

	class QuestionView extends Backbone.View
		tagName: 'li'
		template: _.template $('#question-template').html()

		initialize: =>
			@model.on 'destroy', @remove, @
			@model.on 'change', @render, @

		render: =>
			@$el.html @template @model.toJSON()
			@$('time').timeago()
			@

	class QuestionsView extends Backbone.View
		tagName: 'section'
		template: _.template $('#questions-template').html()

		initialize: =>
			@questions = new Questions
			@questions.on 'add', @addOne, @
			@questions.on 'reset', @addAll, @

		render: ->
			@$el.html(@template).attr('id', 'main')
			@questions.fetch data:
				productId: '2760145242091375915'
			@

		addOne: (question) ->
			view = new QuestionView model: question
			@('.collection').append view.render().el

		addAll: ->
			@questions.each @addOne, @

	class AppView extends Backbone.View
		el: $ 'body'
		template: _.template $('#app-template').html()
		events:
			'click #btn-question': 'openQuestion'
		views: {}

		initialize: ->
			@$el.html @template
			@openQuestion()

		openQuestion: ->
			@clear()
			@views.questions = new QuestionsView
			@$el.append @views.questions.render().el

		clear: ->
			view.remove() for name, view of @views

	appView = new AppView
	appView.render()