# @Chargers = new Mongo.Collection("chargers")

# if Meteor.isClient

  # # counter starts at 0
  # Session.setDefault "counter", 0
  # Template.hello.helpers counter: ->
  #   Session.get "counter"

  # Template.hello.events "click button": ->

  #   # increment the counter when button is clicked
  #   Session.set "counter", Session.get("counter") + 1
  #   return


if Meteor.isServer
  Meteor.startup ->

    # code to run on server at startup
    HTTP.get "http://supercharge.info/service/supercharge/allSites", {}, (error, result) ->
      unless result.statusCode == 200
        console.log "error #{error}"
        return
      else
        # Chargers.remove({})
        for site in JSON.parse(result.content)
          console.log site

    # Chargers.remove({})
    for site in all_sites
      site_id = site.id
      delete site['id']
      site['site_id'] = site_id

      r = Chargers.find({id: site.site_id}).fetch()
      if r.length is 0
        console.log "inserting new #{site.site_id}"
        Chargers.insert site
      else
        console.log "updating #{site.site_id}"
        Chargers.update({_id: r._id}, site)

    Meteor.publish "open-chargers", ->
      Chargers.find({}, {sort: {name: 1}})

    # REVIEW: Logged in to update
    Chargers.allow({
      update: -> true
    })
