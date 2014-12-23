urlEncode = (s) ->
  encoded = ''
  for c in s
    if c.match /[a-zA-Z0-9]/
      encoded += c
    else
      encoded += "%#{c.charCodeAt(0).toString(16)}"
  encoded

Template.charger.helpers
  full_name: ->
    result = @name
    # if @address? and @address.country?
    #   result += ", #{@address.country}"

    result

  city_state_zip: ->
    value = ''
    if @address?
      value += @address.city if @address.city?
      value += ", #{@address.state}" if @address.state?
      value += ", #{@address.zip}" if @address.zip?
      value += " #{@address.country}" if @address.country?
    value

  lat_lon_query: ->
    return "https://maps.google.com/?q=#{urlEncode("#{@gps.latitude},#{@gps.longitude}")}" if @gps?

  tesla_count: ->
    if @teslaCount? then @teslaCount else 0

  line_count: ->
    if @lineCount? then @lineCount else 0

  ice_count: ->
    if @iceCount? then @iceCount else 0

  offline_count: ->
    if @offlineCount? then @offlineCount else 0

  round_to_2: (num) ->
    Math.round(num * 100, 2) / 100

Template.charger.events(
  "click .increment": (e) ->
    console.log "increment. name=#{$(e.target).attr('name')}"
    switch $(e.target).attr('name')
      when 'teslas' then Meteor.call('increment_tesla_count', @, 1)
      when 'line_count' then Meteor.call('increment_line_count', @, 1)
      when 'ice_count' then Meteor.call('increment_ice_count', @, 1)
      when 'offline_count' then Meteor.call('increment_offline_count', @, 1)
    # u = Updates.findOne()
    # console.log "updating to #{ Date.now()} #{Meteor.user()?.username}"
    # if u?
    #   Updates.update({_id: u._id}, {$set: {updated_at: Date.now(), updated_by: Meteor.user()?.username}})
    # else
    #   Updates.insert({updated_at: Date.now(), updated_by: Meteor.user()?.username})

  "click .decrement": (e) ->
    switch $(e.target).attr('name')
      when 'teslas' then Meteor.call('increment_tesla_count', @, -1)
      when 'line_count' then Meteor.call('increment_line_count', @, -1)
      when 'ice_count' then Meteor.call('increment_ice_count', @, -1)
      when 'offline_count' then Meteor.call('increment_offline_count', @, -1)
)
