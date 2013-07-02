jQuery ->
  HOST = 'http://bapul.cloudapp.net/rest/'
  APPLICATION = 'MATH'

  ################################################################
  ### Member ==================================================###
  class Member extends Backbone.Model
    urlRoot: HOST + 'member'
    parse: (response) ->
      response

  class MemberList extends Backbone.Collection
    url: HOST + 'member'
    model: Member
    parse: (response) ->
      response.items

  class MemberView extends Backbone.View
    el: $ '.member-box'
    template: _.template $('#member-template').html()

    initialize: ->
      _.bindAll @
      @profile_view = new ProfileView model: @model
      @

    render: ->
      $(@el).html @template @model.toJSON()
      @

    toggle: ->
      @profile_view.toggle(@$('.view-button'))
      @

    events:
      'click .view-button': 'toggle'


  class MemberListView extends Backbone.View
    el: $ '.member-square'
    template: _.template $('#members-template').html()
    list_div: '.member-box'

    constructor: (@principal) ->
      super()

    initialize: ->
      _.bindAll @

      @members = new MemberList
      @members.bind 'add', @appendItem
      @render()

    render: ->
      $(@el).append(@template)
      @addList()
      @

    addList: ->
      @members.fetch data:
        principal: @principal
      @

    appendItem: (item)->
      member_view = new MemberView model: item
      @$(@list_div).empty().append member_view.render().el

  class ProfileView extends Backbone.View
    el: $ '.member-profile'
    template: _.template $('#profile-template').html()

    initialize: ->
      _.bindAll @
      @profile_open = false
      @

    render: ->
      $(@el).html @template @model.toJSON()
      @

    toggle :(dom) ->
      if @profile_open
        dom.removeClass('active')
        @close()
      else
        dom.addClass('active')
        @open()

    open: ->
      @profile_open = true
      @render()
      $('.member-content').hide()
      $('.member-profile').show()
      @

    close: ->
      @profile_open = false
      $('.member-content').show()
      $('.member-profile').hide()
      @

  ##################################################################
  ### Question ==================================================###
  class Question extends Backbone.Model
    urlRoot: HOST + 'item'
    parse: (response) ->
      member = response.member
      member.username = member.username ? member.principal
      replies = response.replies
      replyActive = 'active' if replies.length > 0 ? ''
      response.replyActive = replyActive
      response

  class QuestionList extends Backbone.Collection
    url: HOST + 'items'
    model: Question
    parse: (response) ->
      response.items

  class QuestionView extends Backbone.View
    tagName: 'div'
    className: 'question ym-grid'
    template: _.template $('#question-template').html()

    initialize: ->
      _.bindAll @

      @model.bind 'destroy', @remove, @
      @model.bind 'change', @render, @

    render: ->
      $(@el).html @template @model.toJSON()
      @$('time').timeago()
      @

    detail: ->
      new QuestionDetailView model: @model

    events:
      'click .delete': 'remove'
      'click .question-background': 'detail'

  class QuestionDetailView extends Backbone.View
    el: $ '.question-detail-box'
    template: _.template $('#question-detail-template').html()

    initialize: ->
      _.bindAll @
      @render()

    render: ->
      @open()
      $(@el).html @template @model.toJSON()
      @$('time').timeago()
      @

    open: ->
      $('.feed-roll').hide()
      $('.question-detail-roll').show()

    close: ->
      console.log 'close question detail'
      $('.question-detail-roll').hide()
      $('.feed-roll').show()

    events:
      'click .close-button': 'close'

  class QuestionListView extends Backbone.View
    el: $ '.question-box'
    template: _.template $('#questions-template').html()
    list_div: '.question-list'

    constructor: (@principal) ->
      super()

    initialize: ->
      _.bindAll @

      @questions = new QuestionList
      @questions.bind 'add', @appendItem

      @offset = 0
      @limit = 10
      @render()

    render: ->
      $(@el).append(@template)
      @addList()
      @

    appendItem: (item) ->
      item_view = new QuestionView model: item
      @$(@list_div).append item_view.render().el

    addList: ->
      @questions.fetch data:
        productId: '2760145242091375915'
        offset: @offset
        limit: @limit
        principal: @principal
      @offset += 10

    events: ->
      'click #next': 'addList'

  ##############################################################
  ### Talk ==================================================###
  class Talk extends Backbone.Model
    urlRoot: HOST + 'talk'
    parse: (response) ->
      member = response.member
      member.username = member.username ? member.principal
      response

  class Talks extends Backbone.Collection
    url: HOST + 'talks'
    model: Talk
    parse: (response) ->
      response.items

  class TalkView extends Backbone.View
    tagName: 'div'
    className: 'feed'
    template: _.template $('#feed-template').html()

    initialize: ->
      _.bindAll @

      @model.bind 'destroy', @remove, @
      @model.bind 'change', @render, @

    render: ->
      $(@el).html @template @model.toJSON()
      @$('time').timeago()
      @

  class TalksView extends Backbone.View
    el: $ '.feed-box'
    template: _.template $('#feeds-template').html()
    list_div: '.feed-window'

    initialize: ->
      _.bindAll @

      @talks = new Talks
      @talks.bind 'add', @appendItem

      @offset = 0
      @limit = 10
      @render()

    render: ->
      $(@el).append(@template)
      @addList()
      @

    addList: ->
      @talks.fetch data:
        productId: '2760145242091375915'
        application: 'MATH'
        offset: @offset
        limit: @limit
      @offset += 10

    appendItem: (item) ->
      item_view = new TalkView model: item
      @$(@list_div).append item_view.render().el

  class Topic extends Backbone.Model
    urlRoot: HOST + 'topic'
    parse: (response) ->
      response

  class TopicList extends Backbone.Collection
    url: HOST + 'topics'
    model: Member
    parse: (response) ->
      response.items

  class TopicView extends Backbone.View
    tagName: 'li'
    className: 'tag'
    template: _.template $('#topic-template').html()

    initialize: ->
      _.bindAll @

    render: ->
      $(@el).html @template @model.toJSON()
      @

  class TopicListView extends Backbone.View
    el: $ '.topics-box'
    template: _.template $('#topics-template').html()
    list_div: 'dl'

    constructor: (@principal) ->
      super()

    initialize: ->
      _.bindAll @
      @topics = new TopicList
      @topics.bind 'add', @appendItem
      @render()

    render: ->
      $(@el).append(@template)
      @addList()
      @

    addList: ->
      @topics.fetch data:
        principal : @principal
      @

    appendItem: (item)->
      topic_view = new TopicView model: item
      @$(@list_div).append topic_view.render().el

  #############################################################
  ### App ==================================================###
  class AppView extends Backbone.View
    principal = 'tester'
    initialize: ->
      @render()
      $('.member-image').click ->
        @principal = $(this).attr 'id'
        console.log @principal
        @render()

    render: ->
      member_list_view = new MemberListView @principal
      topic_list_view = new TopicListView @principal
      quesiton_list_view = new QuestionListView @principal
      talks_view = new TalksView




  app = new AppView

