Template.charger.helpers
  full_name: ->
    result = ''
    if @address? and @address.country?
      result = "#{@name}, #{@address.country}"
    else
      result = @name
    result

  city_state_zip: ->
    value = ''
    if @address?
      value += @address.city if @address.city?
      value += ", #{@address.state}" if @address.state?
      value += ", #{@address.zip}" if @address.zip?
      value += " #{@address.country}" if @address.country?
    value

  tesla_count: ->
    if @teslaCount? then @teslaCount else 0

  line_count: ->
    if @lineCount? then @lineCount else 0

  ice_count: ->
    if @iceCount? then @iceCount else 0

counter_map = {
  teslas: 'teslaCount',
  line_count: 'lineCount',
  ice_count: 'iceCount'
}

Template.charger.events(
  "click .increment": (e) ->
    console.log "click #{$(e.target).attr('name')} for id #{@_id}"
    switch $(e.target).attr('name')
      when 'teslas' then Chargers.update({_id: @_id}, {$inc: {teslaCount: 1}})
      when 'line_count' then Chargers.update({_id: @_id}, {$inc: {lineCount: 1}})
      when 'ice_count' then Chargers.update({_id: @_id}, {$inc: {iceCount: 1}})

  "click .decrement": (e) ->
    console.log "click #{$(e.target).attr('name')}"
    switch $(e.target).attr('name')
      when 'teslas' then  Chargers.update({_id: @_id}, {$inc: {teslaCount: -1}})
      when 'line_count' then Chargers.update({_id: @_id}, {$inc: {lineCount: -1}})
      when 'ice_count' then Chargers.update({_id: @_id}, {$inc: {iceCount: -1}})
)
