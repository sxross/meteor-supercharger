Meteor.publish "open_chargers", (limit=5) ->
  Chargers.find {},
    sort:
      "address.country": 1
      "address.state": 1
      name: 1
    limit: limit

