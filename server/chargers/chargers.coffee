@inspect = (o) ->
  r = []
  r.push("#{key} = #{value}") for own key, value of o
  r.join("\n")

@is_production = ->
  return !_.isEmpty process.env.ROOT_URL.match(/meteor\.com/i)

Meteor.methods
  insert_or_update: (site, origin = 'remote') ->
    status =
      insert_count: 0
      update_count: 0
      error_count:  0

    r = Chargers.find({id: site.id}).fetch()
    if r.length is 0
      site.dateOpened   = new Date(site.dateOpened)
      site.dateModified = new Date(site.dateModified)
      site = _.extend {teslaCount: 0, iceCount: 0, lineCount: 0, offlineCount: 0}, site
      Chargers.insert site, (error, result) ->
        if error
          console.log "inserting site #{site} error code: #{error}"
          status.error_count += 1
        else
          status.insert_count += 1
    else
      site.dateOpened   = new Date(site.dateOpened)
      site.dateModified = new Date(site.dateModified)
      site = _.extend {teslaCount: 0, iceCount: 0, lineCount: 0, offlineCount: 0}, site
      Chargers.update {_id: r._id}, {$set: site}, (error, result) ->
        if error
          console.log "updating site #{site} error code: #{error}"
          status.error_count += 1
        else
          status.update_count += 1
          
    return status

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
