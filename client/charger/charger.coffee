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

# Template.charger.full_name = ->
#   if @address.country.length > 0
#     return "#{@name}, #{@address.country}"
#   else
#     return @name

# Template.charger.city_state_zip = ->
#   value = @address.city
#   value += ", #{@address.state}" if @address.state
#   value += ", #{@address.zip}" if @address.zip
#   value

# Template.charger.tesla_count = ->
#   if @teslaCount? then @teslaCount else 0

# Template.charger.line_count = ->
#   if @lineCount? then @lineCount else 0

# Template.charger.ice_count = ->
#   if @iceCount? then @iceCount else 0

Template.charger.events(
  "click .increment": (e) ->
    switch $(e.target).attr('name')
      when 'teslas' then Chargers.update({_id: @_id}, {$inc: {teslaCount: 1}})
      when 'line_count' then Chargers.update({_id: @_id}, {$inc: {lineCount: 1}})
      when 'ice_count' then Chargers.update({_id: @_id}, {$inc: {iceCount: 1}})

  "click .decrement": (e) ->
    switch $(e.target).attr('name')
      when 'teslas' then  Chargers.update({_id: @_id}, {$inc: {teslaCount: -1}})
      when 'line_count' then Chargers.update({_id: @_id}, {$inc: {lineCount: -1}})
      when 'ice_count' then Chargers.update({_id: @_id}, {$inc: {iceCount: -1}})
)
