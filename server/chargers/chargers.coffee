@inspect = (o) ->
  r = []
  r.push("#{key} = #{value}") for own key, value of o
  r.join("\n")

@is_production = ->
  return !_.isEmpty process.env.ROOT_URL.match(/meteor\.com/i)

@send_mail = (mail_body) ->
  Email.send(
    from:    'admin@supercharger.meteor.com'
    to:      'sxross@gmail.com'
    subject: "Charger Sync: #{moment(Date.now()).format('L LT')}"
    text:    mail_body
  )


@run_stats =
  insert_count: 0
  update_count: 0
  error_count:  0

Meteor.methods
  insert_or_update: (site, origin = 'remote') ->

    r = Chargers.find({id: site.id}).fetch()
    if r.length is 0
      site.dateOpened   = new Date(site.dateOpened)
      site.dateModified = new Date(site.dateModified)
      site = _.extend {teslaCount: 0, iceCount: 0, lineCount: 0, offlineCount: 0}, site
      Chargers.insert site, (error, result) ->
        if error
          run_stats.error_count += 1
          return 'error'
        else
          run_stats.insert_count += 1
          return 'updated'
    else
      site.dateOpened   = new Date(site.dateOpened)
      site.dateModified = new Date(site.dateModified)
      site = _.extend {teslaCount: 0, iceCount: 0, lineCount: 0, offlineCount: 0}, site
      Chargers.update {_id: r._id}, {$set: site}, (error, result) ->
        if error
          run_stats.error_count += 1
          return 'error'
        else
          run_stats.update_count += 1
          return 'updated'

    return run_stats

  updateChargers: ->
    mail_ary = []
    location = 'remote'

    unless is_production()
      location = 'local'
      for site in all_sites
        result = Meteor.call('insert_or_update', site, location)
        mail_ary.push "#{location} : #{site.name} : #{result}"

      send_mail mail_ary.join("\n")
    else
      HTTP.get "http://supercharge.info/service/supercharge/allSites", {}, (error, result) ->
        unless result.statusCode == 200
          console.log "error #{error}"
          return
        else
          for site in JSON.parse(result.content)
            result = Meteor.call('insert_or_update', site, location)
            mail_ary.push "#{location} : #{site.name} : #{result}"

          send_mail mail_ary.join("\n")
