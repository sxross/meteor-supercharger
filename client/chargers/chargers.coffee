Template.chargers.list = ->
  console.log 'Template.chargers.list'
  # [{name: 'dog'}, {name: 'cat'}, {name: 'bat'}]
  Chargers.find({})
  # console.log charger.name for charger in @Chargers

Template.chargers.charger_count = ->
  console.log 'Template.chargers.charger_count'
  Chargers.find({}).count()
