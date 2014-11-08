Meteor.startup ->
  Meteor.call 'updateChargers'

  SyncedCron.add
    name: "Update Charger Information"
    schedule: (parser) ->

      # parser is a later.parse object
      parser.text "every 12 hours"

    job: ->
      Meteor.call 'updateChargers'

  SyncedCron.start()

  Meteor.publish "open-chargers", ->
    Chargers.find({}, {sort: {'address.country':1, 'address.state':1, name: 1}})

  # REVIEW: Logged in to update
  Chargers.allow({
    update: -> true
  })


