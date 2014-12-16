describe 'Chargers', ->
  beforeEach ->
    MeteorStubs.install()
    mock(global, 'Chargers')

  it 'Detects development mode if not on meteor', ->
    process.env.ROOT_URL = 'localhost'
    expect(is_production()).toBeFalsy()

  it 'Detects production mode if on meteor', ->
    process.env.ROOT_URL = 'supercharger.meteor.com'
    expect(is_production()).toBeTruthy()

  it 'Adds count fields to a charger', ->
    Meteor.call 'insert_or_update',
      "id": 100
      "name": "Buckeye, AZ"
      "status": "OPEN"
      "address":
        "street": "416 S Watson RD"
        "city": "Buckeye"
        "state": "AZ"
        "zip": "85326"
        "country": "USA"
      "gps":
        "latitude": 33.443011
        "longitude": -112.556876

    obj = {}
    spyOn(Chargers, "find").and.returnValue(obj)
    spyOn(obj, "fetch").andReturn([
      "_id": 'sdkfhjdaskj'
      "id": 100
      "name": "Buckeye, AZ"
      "status": "OPEN"
      "address":
        "street": "416 S Watson RD"
        "city": "Buckeye"
        "state": "AZ"
        "zip": "85326"
        "country": "USA"
      "gps":
        "latitude": 33.443011
        "longitude": -112.556876

      ])
    expect(Chargers.find().count()).toEqual(1)
    expect(Chargers.findOne().name).toEqual('Buckeye, AZ')
