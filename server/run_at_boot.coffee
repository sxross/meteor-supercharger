Meteor.startup ->
  Meteor.call 'updateChargers'

  SyncedCron.add
    name: "Update Charger Information"
    schedule: (parser) ->

      # parser is a later.parse object
      parser.text "at 12:05am every day"

    job: ->
      Meteor.call 'updateChargers'

  SyncedCron.start()

  Meteor.publish "open-chargers", ->
    Chargers.find({}, {sort: {'address.country':1, 'address.state':1, name: 1}})
