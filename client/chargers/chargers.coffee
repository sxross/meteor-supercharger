# Autorun subscription for infinite scroll
# ITEMS_INCREMENT = 50
# Session.setDefault "itemsLimit", ITEMS_INCREMENT
# Deps.autorun ->
#   Meteor.subscribe "open_chargers", Session.get("itemsLimit")
#   return

Template.chargers.helpers
  list: ->
    search_query = Session.get('search_query')
    if search_query
      return Chargers.find({name: new RegExp(".*#{search_query}.*", "i")})
      return Chargers.find({name: new RegExp(".*#{search_query}.*", "i")})
    else
      # return Chargers.find({}, {limit: Session.get("itemsLimit")})
      return Chargers.find({})

  charger_count: ->
    return Chargers.find({}).count()

  empty: ->
    Chargers.find({}).count() is 0

# More results placeholder for infinite scroll
  moreResults: ->
    search_query = Session.get('search_query')
    if search_query
      return Chargers.find({name: new RegExp(".*#{search_query}.*", "i")}).count() >= Session.get("itemsLimit")
    else
      return Chargers.find({}).count() >= Session.get("itemsLimit")

# Infinite scroll
showMoreVisible = ->
  threshold = undefined
  target = $("#showMoreResults")
  return unless target.length
  threshold = $(window).scrollTop() + $(window).height() - target.height()
  if target.offset().top <= threshold
    unless target.data("visible")
      target.data "visible", true
      Session.set "itemsLimit", Session.get("itemsLimit") + ITEMS_INCREMENT
  else
    target.data "visible", false  if target.data("visible")
  return

# run the above func every time the user scrolls
# $(window).scroll showMoreVisible
