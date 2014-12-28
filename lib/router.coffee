Router.configure
  layoutTemplate: "layout"
  loadingTemplate: "loading"
  notFoundTemplate: "notFound"

Router.route "/",
  waitOn: ->
    if Meteor.isClient
      country_prefs = Session.get(COUNTRY_PREFS)
      state_prefs   = Session.get(STATE_PREFS)
    Meteor.subscribe "open_chargers", country_prefs, state_prefs
    Meteor.subscribe "updates"
  name: "chargers"
  fastRender: true
  # onBeforeAction: (pause) ->
  #   console.log "before action route name is #{@route.getName()}"
  #   routeName = @route.getName()

  #   # don't try to log into logged in routes
  #   return if _.include(['login'], routeName)

  #   Router.go('/login')

    # unless Meteor.userId()
    #   @setLayout("newLayout")
    #   @render('login')

    #   # if you have named yields it the login form
    #   @render('loginForm', {to:"formRegion"});

    #   # and finally call the pause() to prevent further actions from running
    #   pause();
    # else
    #   @setLayout(@lookupLayoutTemplate())

Router.route "/about",
  name: "about"

Router.route "/changelog",
  name: "changelog"

Router.route "/settings",
  name: "settings"
  fastRender: true
  waitOn: ->
    Meteor.subscribe "geography", null, null

# Router.route "login",
#   name: "login"
#   layoutTemplate: "loginTemplate"

# Router.route "/posts/:_id",
#   name: "postPage"
#   data: ->
#     Posts.findOne @params._id

# Router.route "/posts/:_id/edit",
#   name: "postEdit"
#   data: ->
#     Posts.findOne @params._id

# Router.route "/submit",
#   name: "postSubmit"

# Router.onBeforeAction "dataNotFound",
#   only: "postPage"

# Router.onBeforeAction requireLogin,
#   only: "postSubmit"
