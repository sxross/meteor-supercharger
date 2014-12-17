Template.header.events
  'click li > a': ->
    console.log 'click'
    $(".navbar-collapse").removeClass('in').addClass('collapse')
