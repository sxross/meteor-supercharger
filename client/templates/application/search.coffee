Template.search.events
  "keyup #search": (e) ->
    e.preventDefault()
    Session.set('search_query', $('#search>input').val())
