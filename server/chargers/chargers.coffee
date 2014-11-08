Meteor.methods
  insert_or_update: (site, origin = 'remote') ->
    console.log "insert_or_update #{site.name}"

    r = Chargers.find({id: site.id}).fetch()
    if r.length is 0
      site.dateOpened = Date.parse(site.dateOpened) || Date.today()
      console.log "date is #{site.dateOpened} -- #{(typeof site.dateOpened)}"
      Chargers.insert site, (error, result) ->
        console.log "inserting site #{site} error code: #{error}"
    else
      site.dateOpened = Date.parse(site.dateOpened) || Date.today()
      console.log "date is #{site.dateOpened} -- #{(typeof site.dateOpened)}"
      Chargers.update {_id: r._id}, {$set: site}, (error, result) ->
        console.log "updating site #{site} error code: #{error}"

  updateChargers: ->
    location = 'remote'
    console.log "testing #{Meteor.absoluteUrl()} and got #{Meteor.absoluteUrl().match(/dev0|:3000/)}"
    if Meteor.absoluteUrl().match(/dev0|:3000/) isnt null
      location = 'local'
      Meteor.call('insert_or_update', site, location) for site in all_sites
    else
      HTTP.get "http://supercharge.info/service/supercharge/allSites", {}, (error, result) ->
        unless result.statusCode == 200
          console.log "error #{error}"
          return
        else
          # Chargers.remove({})
          Meteor.call('insert_or_update', site, location) for site in JSON.parse(result.content)
