Meteor.publish "open_chargers", ->
  if this.userId
    console.log "publishing because user is logged in"
    Chargers.find {status: 'OPEN'},
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
  else
    null

Meteor.publish "updates", (limit=1) ->
  Updates.find {},
    sort:
      updated_at: 1
    limit: 1
