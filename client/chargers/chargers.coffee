# Autorun subscription for infinite scroll
ITEMS_INCREMENT = 5
Session.setDefault "itemsLimit", ITEMS_INCREMENT
Deps.autorun ->
  console.log "rerunning subscription for #{Session.get("itemsLimit")}"
  Meteor.subscribe "open_chargers", Session.get("itemsLimit")
  return

Template.chargers.helpers
  list: ->
    return Chargers.find({}, {limit: Session.get("itemsLimit")})

  charger_count: ->
    return Chargers.find({}).count()

# More results placeholder for infinite scroll
  moreResults: ->
    Chargers.find().count() >= Session.get("itemsLimit")

# Infinite scroll
showMoreVisible = ->
  threshold = undefined
  target = $("#showMoreResults")
  return  unless target.length
  threshold = $(window).scrollTop() + $(window).height() - target.height()
  if target.offset().top < threshold
    unless target.data("visible")

      # console.log("target became visible (inside viewable area)");
      target.data "visible", true
      Session.set "itemsLimit", Session.get("itemsLimit") + ITEMS_INCREMENT
  else

    # console.log("target became invisible (below viewable arae)");
    target.data "visible", false  if target.data("visible")
  return

# run the above func every time the user scrolls
$(window).scroll showMoreVisible
