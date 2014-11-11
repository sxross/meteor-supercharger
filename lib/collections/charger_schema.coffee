@Chargers = new Mongo.Collection("chargers")

Chargers.allow
  update: -> true
