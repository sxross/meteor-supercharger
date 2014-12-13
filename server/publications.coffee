Meteor.publish "open_chargers", (limit=5) ->
  if this.userId
    console.log "publishing because user is logged in"
    Chargers.find {},
      sort:
        "address.country": 1
        "address.state": 1
        name: 1
      limit: limit
  else
    console.log "not publishing because user is not logged in"
    null

Meteor.publish "updates", (limit=1) ->
  Updates.find {},
    sort:
      updated_at: 1
    limit: 10

