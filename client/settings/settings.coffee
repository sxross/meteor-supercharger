@COUNTRY_PREFS = 'country_prefs'
@STATE_PREFS   = 'state_prefs'

charger_constraints = (prefs) ->
  constraints = []
  constraints.push {'address.country': {$in: prefs.country}} unless _.isEmpty(prefs.country)
  constraints.push  {'address.state': {$in: prefs.state}} unless _.isEmpty(prefs.state)
  return if _.isEmpty(constraints) then {} else {$and: constraints}

map_chargers = (cursor, options) ->
  _.sortBy(
    _.reject(
      _.uniq(
        _.map(
          cursor.fetch(), options.map_function
        ), false, options.uniq_function
      ), options.reject_function
    ), options.sort_string
  )

Template.settings.helpers
  charger_count: ->
    constraints = charger_constraints(
      state: Session.get(STATE_PREFS)
      country: Session.get(COUNTRY_PREFS)
    )
    Chargers.find(constraints).count()

Template.states.helpers
  list: ->
    result_map = {}

    country_prefs = Session.get(COUNTRY_PREFS)
    search_prefs = {}
    unless _.isEmpty(country_prefs)
      _.extend search_prefs,
        "address.country":
          $in: country_prefs

    map_chargers(
      Chargers.find(search_prefs, fields: {'address.state':1, 'address.country':1}),
        map_function: (item) -> {state: item.address.state}
        uniq_function: (item) -> item.state
        reject_function: (item) -> _.isEmpty(item.state)
        sort_string: 'state'
      )

Template.states.events
  'click #state-button': (e) ->
    $('#state-list').toggle(400)

Template.state_setting.events
  'click .state': (e) ->
    prefs = Session.get(STATE_PREFS) || []
    value = $(e.target).val()
    if _.contains(prefs, value)
      prefs = _.reject prefs, (item) ->
        item is value
    else
      prefs.push $(e.target).val()
    Session.set(STATE_PREFS, _.uniq(prefs))

Template.state_setting.helpers
  is_checked: ->
    settings = Session.get(STATE_PREFS)
    _.contains(settings, @state) ? 'checked' : false

Template.countries.helpers
  list: ->
    map_chargers(
      Chargers.find({}, fields: {'address.state':1, 'address.country':1}),
        map_function: (item) -> {country: item.address.country}
        uniq_function: (item) -> item.country
        reject_function: (item) -> _.isEmpty(item.country)
        sort_string: 'country'
      )

Template.countries.rendered = ->
  _.each Session.get(COUNTRY_PREFS), (e) ->
    $("li > input[value=#{e}]").attr('checked', true)

Template.countries.events
  'click .country': (e) ->
    country_prefs = []
    country_prefs = _.map $('.country:checked'), (iteratee) -> $(iteratee).val()
    Session.set(COUNTRY_PREFS, country_prefs)

  'click #country-button': (e) ->
    $('#country-list').toggle(400)
