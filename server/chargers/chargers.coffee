@inspect = (o) ->
  r = []
  r.push("#{key} = #{value}") for own key, value of o
  r.join("\n")

is_production = ->
  console.log "root url: #{process.env.ROOT_URL}"
  process.env.ROOT_URL.match(/meteor\.com/i)

Meteor.methods
  insert_or_update: (site, origin = 'remote') ->
    r = Chargers.find({id: site.id}).fetch()
    if r.length is 0
      site.dateOpened   = new Date(site.dateOpened)
      site.dateModified = new Date(site.dateModified)
      site = _.extend {teslaCount: 0, iceCount: 0, lineCount: 0, offlineCount: 0}, site
      Chargers.insert site, (error, result) ->
        console.log "inserting site #{site} error code: #{error}" if error
    else
      site.dateOpened   = new Date(site.dateOpened)
      site.dateModified = new Date(site.dateModified)
      site = _.extend {teslaCount: 0, iceCount: 0, lineCount: 0, offlineCount: 0}, site
      Chargers.update {_id: r._id}, {$set: site}, (error, result) ->
        console.log "updating site #{site} error code: #{error}" if error

  updateChargers: ->
    location = 'remote'
    unless is_production()
      location = 'local'
      Meteor.call('insert_or_update', site, location) for site in all_sites
    else
      HTTP.get "http://supercharge.info/service/supercharge/allSites", {}, (error, result) ->
        unless result.statusCode == 200
          console.log "error #{error}"
          return
        else
          Meteor.call('insert_or_update', site, location) for site in JSON.parse(result.content)
