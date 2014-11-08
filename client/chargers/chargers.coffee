Template.chargers.helpers
  list: ->
    return Chargers.find({}, {limit:50})
    # return Chargers.find({})

  charger_count: ->
    return Chargers.find({}).count()
