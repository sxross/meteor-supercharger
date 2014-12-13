@Updates = new Mongo.Collection("updates")

Updates.allow
  update: -> true
  insert: -> true
