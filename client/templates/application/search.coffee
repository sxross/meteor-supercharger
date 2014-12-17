Template.search.events
  "click #toggle-search": (e) ->
    e.preventDefault()
    $('#search_row').toggle()

Template.search_bar.helpers
  isChargerPage: ->
    console.log "page is #{Router.current().route.getName()}"
    Router.current().route.getName() is 'chargers'

Template.search_bar.events
  "input, change, keyup #search": (e) ->
    e.preventDefault()
    Session.set('search_query', $('input#search').val())

  "cut paste #search": (e) ->
    Session.set('search_query', $('input#search').val())
