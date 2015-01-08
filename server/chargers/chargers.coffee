@inspect = (o) ->
  JSON.stringify o

@is_production = ->
  return true
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
  site_count:   0

Meteor.methods
  insert_or_update: (site) ->
    return null if MochaWeb?

    doc = new ChargerServerDoc(Chargers.findOne({id:site.id}), site)

    doc.set_defaults().merge().needs_update
      update: (id, doc) ->
        Chargers.update id, $set: doc, (error, result) ->
          unless _.isEmpty(error)
            console.log "updating error is #{inspect(error)} result is #{inspect(result)}"
            run_stats.error_count += 1
            "error"
          else
            run_stats.update_count += 1
            "update"

        return

      insert: (doc) ->
        Chargers.insert doc, (error, result) ->
          unless _.isEmpty(error)
            console.log "insert error is #{inspect(error)} result is #{inspect(result)}"
            run_stats.error_count += 1
            "error"
          else
            run_stats.insert_count += 1
            "insert"

        return

    return null

  updateChargers: ->
    mail_ary = []
    run_stats.error_count = run_stats.insert_count = run_stats.update_count = run_stats.site_count = 0
    location = 'remote'

    unless is_production()
      location = 'local'
      for site in all_sites
        run_stats.site_count += 1
        result = Meteor.call('insert_or_update', site)
        mail_ary.push "#{location} : #{site.name} : #{result}" unless _.isNull(result)
    else
      HTTP.get "http://supercharge.info/service/supercharge/allSites", {}, (error, result) ->
        unless result.statusCode == 200
          mail_ary.push "HTTP connection error #{result.statusCode} : #{JSON.stringify error}"
        else
          for site in JSON.parse(result.content)
            run_stats.site_count += 1
            result = Meteor.call('insert_or_update', site, location)
            mail_ary.push "#{location} : #{site.name} : #{result}" unless _.isNull(result)

    mail_ary.push """

    sites:        #{run_stats.site_count}

    errors:       #{run_stats.error_count}
    inserts:      #{run_stats.insert_count}
    updates:      #{run_stats.update_count}
    """
    send_mail mail_ary.join("\n")
