@Chargers = new Mongo.Collection("chargers")

Chargers.allow
  update: -> true
  insert: ->
    !_.isEmpty MochaWeb

login_check = ->
  return true if Meteor.user()
  Errors.throw 'You must be logged in to change count.'

# range_check(actual, options) -- test actual number against an upper and lower limit.
# if limits are exceeded, throw an Error. Note, setting upper or lower to null skips
# that range test
range_check = (actual, options) ->
  _.defaults(options, {upper: null, lower: 0, upper_limit_message: "You can't do that. Too many.", lower_limit_message: "You can't do that. Too few."})
  Errors.throw options.upper_limit_message if !_.isNull(options.upper) and actual > options.upper
  Errors.throw options.lower_limit_message if !_.isNull(options.lower) and actual < options.lower

doc_check = (doc, direction) ->
  check(doc, Object)
  check(direction, Number)

set_update_info = ->
  u = Updates.findOne()
  if u?
    Updates.update({_id: u._id}, {$set: {updated_at: Date.now(), updated_by: Meteor.user()?.username}})
  else
    Updates.insert({updated_at: Date.now(), updated_by: Meteor.user()?.username})

Meteor.methods
  increment_tesla_count: (doc, direction) ->
    # Limit new value to be <= number of available spaces which is defined
    # as number of stalls minus those offline or ICEd
    doc_check doc, direction
    login_check()
    range_check doc.teslaCount + direction,
      lower: 0,
      upper: doc.stallCount - doc.iceCount - doc.offlineCount
      upper_limit_message: "Too many Teslas. There don't seem to be as many stalls as you are reporting."

    new_value = bounded_value(doc.teslaCount + direction,
      lower: 0
      upper: doc.stallCount - doc.iceCount - doc.offlineCount
      )
    Chargers.update({_id: doc._id}, {$set: {teslaCount: new_value}})
    set_update_info()

  # Limit new value to be >= 0
  increment_line_count: (doc, direction) ->
    doc_check doc, direction
    login_check()
    range_check doc.lineCount + direction, upper: null, lower_limit_message: "you can't have fewer than 0 cars there!"
    new_value = bounded_value(doc.lineCount + direction, lower: 0)
    Chargers.update({_id: doc._id}, {$set: {lineCount: new_value}})
    set_update_info()

  # Limit new value to positive numbers <= stalls avaliable - teslas there
  increment_ice_count: (doc, direction) ->
    doc_check doc, direction
    login_check()
    range_check doc.iceCount + direction,
      lower: 0
      upper: doc.stallCount - doc.teslaCount
      upper_limit_message: "It's impossible for more ICEs than stalls to be present."
    new_value = bounded_value(doc.iceCount + direction, lower: 0, upper: doc.stallCount - doc.teslaCount)
    Chargers.update({_id: doc._id}, {$set: {iceCount: new_value}})
    set_update_info()

  # Limit new value to positive numbers <= stalls avaliable - teslas there
  increment_offline_count: (doc, direction) ->
    doc_check doc, direction,
    login_check()
    range_check doc.offlineCount + direction,
      lower: 0
      upper: doc.stallCount - doc.teslaCount
      upper_limit_message: "It's impossible for more stalls to be offline than there are stalls."
    new_value = bounded_value doc.offlineCount + direction, lower: 0, upper: doc.stallCount - doc.teslaCount
    Chargers.update({_id: doc._id}, {$set: {offlineCount: new_value}})
    set_update_info()
