@Chargers = new Mongo.Collection("chargers")

Chargers.allow
  update: -> true

Meteor.methods
  set_update_info: ->
    u = Updates.findOne()
    console.log "updating to #{ Date.now()} #{Meteor.user()?.username}"
    if u?
      Updates.update({_id: u._id}, {$set: {updated_at: Date.now(), updated_by: Meteor.user()?.username}})
    else
      Updates.insert({updated_at: Date.now(), updated_by: Meteor.user()?.username})

  _doc_check: (doc, direction) ->
    check(doc, Object)
    check(direction, Number)

  _is_valid_user: ->
    Meteor.user()

  increment_tesla_count: (doc, direction) ->
    # Limit new value to be <= number of available spaces which is defined
    # as number of stalls minus those offline or ICEd
    Meteor.call '_doc_check', doc, direction

    if Meteor.call('_is_valid_user')
      new_value = bounded_value(doc.teslaCount + direction,
        lower: 0
        upper: doc.stallCount - doc.iceCount - doc.offlineCount
        )
      # new_value = Math.max(
      #   Math.min(
      #     doc.teslaCount + direction, doc.stallCount - doc.iceCount - doc.offlineCount
      #     ),
      #   0)
      Chargers.update({_id: doc._id}, {$set: {teslaCount: new_value}})
      Meteor.call('set_update_info')
    else
      throw new Meteor.Error 'You must be logged in to change count.'

  # Limit new value to be >= 0
  increment_line_count: (doc, direction) ->
    Meteor.call '_doc_check', doc, direction

    if Meteor.call('_is_valid_user')
      new_value = bounded_value(doc.lineCount + direction, lower: 0)
      Chargers.update({_id: doc._id}, {$set: {lineCount: new_value}})
      Meteor.call('set_update_info')

  # Limit new value to positive numbers <= stalls avaliable - teslas there
  increment_ice_count: (doc, direction) ->
    Meteor.call '_doc_check', doc, direction

    if Meteor.call('_is_valid_user')
      new_value = bounded_value doc.iceCount + direction, lower: 0, upper: doc.stallCount - doc.teslaCount
      Chargers.update({_id: doc._id}, {$set: {iceCount: new_value}})
      Meteor.call('set_update_info')

  # Limit new value to positive numbers <= stalls avaliable - teslas there
  increment_offline_count: (doc, direction) ->
    Meteor.call '_doc_check', doc, direction

    if Meteor.call('_is_valid_user')
      new_value = bounded_value doc.offlineCount + direction, lower: 0, upper: doc.stallCount - doc.teslaCount
      Chargers.update({_id: doc._id}, {$set: {offlineCount: new_value}})
      Meteor.call('set_update_info')
