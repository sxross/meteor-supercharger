MochaWeb?.testOnly ->
  expect = chai.expect
  describe "chargers on the server", ->
    beforeEach ->
      Chargers.remove({})
      @test_doc =
        "id": 601,
        "name": "Test Flagstaff, AZ",
        "status": "OPEN",
        "address": {
          "street": "2650 S Beulah Blvd",
          "city": "Flagstaff",
          "state": "AZ",
          "zip": "86001",
          "country": "USA"
        }
      Chargers.insert @test_doc

    afterEach ->
      Chargers.remove({name: "Test Flagstaff, AZ"})

    it "creates initial harness", ->
      expect(Chargers.find().count()).not.to.equal(0)
      expect(Chargers.find().count()).to.equal(1)
      expect(Chargers.find({name: "Test Flagstaff, AZ"}).count()).to.equal(1)

