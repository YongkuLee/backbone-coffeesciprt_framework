jQuery ->
  HOST = 'http://bapul.cloudapp.net/rest/'

  class Report extends Backbone.Model
    urlRoot: HOST + 'report'

  class Reports extends Backbone.Collection
    url: HOST + 'reports'
    model: Report
    parse: (response) ->
      response.items

  class ReportView extends Backbone.View
    tagName: 'li'
    template: _.template $('#report-template').html()

    initialize: =>
      @model.on 'destroy', @remove, @
      @model.on 'change', @render, @

    render: =>
      @$el.html @template @model.toJSON()
      @$('time').timeago()
      @

  class ReportsView extends Backbone.View
    tagName: 'section'
    template: _.template $('#reports-template').html()

    initialize: =>
      @reports = new Reports
      @reports.on 'add', @addOne, @
      @reports.on 'reset', @addAll, @

    render: ->
      @$el.html(@template).attr('id', 'main')
      @reports.fetch data:
        productId: '2760145242091375915'
      @

    addOne: (report) ->
      view = new ReportView model: report
      @$('.collection').append view.render().el

    addAll: ->
      @notices.each @addOne, @

  class Notice extends Backbone.Model
    urlRoot: HOST + 'notice'

  class Notices extends Backbone.Collection
    url: HOST + 'notices'
    model: Notice
    parse: (response) ->
      response.items

  class NoticeView extends Backbone.View
    tagName: 'li'
    template: _.template $('#notice-template').html()

    initialize: =>
      @model.on 'destroy', @remove, @
      @model.on 'change', @render, @

    render: =>
      @$el.html @template @model.toJSON()
      @$('time').timeago()
      @

  class NoticesView extends Backbone.View
    tagName: 'section'
    template: _.template $('#notices-template').html()

    initialize: =>
      @notices = new Notices
      @notices.on 'add', @addOne, @
      @notices.on 'reset', @addAll, @

    render: ->
      @$el.html(@template).attr('id', 'main')
      @notices.fetch data:
        productId: '2760145242091375915'
      @

    addOne: (notice) ->
      view = new NoticeView model: notice
      @$('.collection').append view.render().el

    addAll: ->
      @notices.each @addOne, @

  class AppView extends Backbone.View
    el: $ 'body'
    template: _.template $('#app-template').html()
    events:
      'click #btn-notice': 'openNotice'
      'click #btn-report': 'openReport'
    views:{}

    initialize: ->
      @$el.html @template
      @openNotice()

    openNotice: ->
      @clear()
      @views.notices = new NoticesView
      @$el.append @views.notices.render().el

    openReport: ->
      @clear()
      @views.reports = new ReportsView
      @$el.append @views.reports.render().el

    clear: ->
      view.remove() for name, view of @views

  appView = new AppView
  appView.render()