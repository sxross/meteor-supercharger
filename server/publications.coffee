charger_constraints = (prefs) ->
  constraints = [{status: 'OPEN'}]
  constraints.push {'address.country': {$in: prefs.country}} unless _.isEmpty(prefs.country)
  constraints.push  {'address.state': {$in: prefs.state}} unless _.isEmpty(prefs.state)
  return {$and: constraints}

Meteor.publish "open_chargers", (country_prefs, state_prefs) ->
  constraints = charger_constraints(
    country: country_prefs
    state:   state_prefs
  )

  result = Chargers.find constraints,
    sort:
      "address.country": 1
      "address.state": 1
      name: 1
    fields:
      name: true
      address: true
      stallCount: true
      gps: true
      elevationMeters: true
      teslaCount: true
      iceCount: true
      lineCount: true
      offlineCount: true

  result

Meteor.publish "updates", (limit=1) ->
  Updates.find {},
    sort:
      updated_at: 1
    limit: 1

Meteor.publish "geography", (country_prefs, state_prefs) ->
  Chargers.find({}, {fields: {'address.country': 1, 'address.state': 1}})
