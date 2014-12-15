Template.search.events
  "click #toggle-search": (e) ->
    e.preventDefault()
    $('#search_row').toggle()

Template.search_bar.events
  "keyup #search": (e) ->
    e.preventDefault()
    Session.set('search_query', $('input#search').val())
