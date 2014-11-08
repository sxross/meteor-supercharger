@Chargers = new Mongo.Collection("chargers")

@Schemas = {}

Schemas.Charger = new SimpleSchema
  id:
    type: Number
    optional: false
  name:
    type: String
    label: "Name"
    max: 200
  site_id:
    type: Number
    label: "Site ID"
  "address.street":
    type: String
    label: "Street"
  "address.city":
    type: String
    label: "City"
    optional: true
  "address.state":
    type: String
    label: "State"
    optional: true
    max: 2
  "address.zip":
    type: String
    label: "Zip"
    optional: true
    max: 6
  "address.country":
    type: String
    label: "Country"
    optional: true
  "gps.latitude":
    type: Number
    decimal: true
    optional: true
  "gps.longitude":
    type: Number
    decimal: true
    optional: true
  elevationMeters:
    type: Number
    optional: true
  status:
    type: String
    optional: true
  url:
    type: String
    optional: true
  urlDiscuss:
    type: String
    optional: true
  stallCount:
    type: Number
    optional: true
  hours:
    type: String
    optional: true
  counted:
    type: Boolean
    optional: true
  dateOpened:
    type: Date
    optional: true
  dateModified:
    type: Date
    optional: true

Chargers.attachSchema(Schemas.Charger)

Chargers.allow
  update: -> true
