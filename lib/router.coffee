Router.configure
  layoutTemplate: "layout"
  loadingTemplate: "loading"
  notFoundTemplate: "notFound"

Router.route "/",
  waitOn: ->
    Meteor.subscribe "open_chargers"
    Meteor.subscribe "updates"
  name: "chargers"

Router.route "/about",
  name: "about"

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

@requireLogin = ->
  unless Meteor.user()
    if Meteor.loggingIn()
      @render @loadingTemplate
    else
      @render "accessDenied"
  else
    @next()
  return

# Router.onBeforeAction "dataNotFound",
#   only: "postPage"

# Router.onBeforeAction requireLogin,
#   only: "postSubmit"
