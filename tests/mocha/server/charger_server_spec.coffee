MochaWeb?.testOnly ->
  expect = chai.expect
  describe "chargers on the server", ->
    beforeEach ->
      console.log "removing all chargers"
      Chargers.remove({})
      console.log "there are now #{Chargers.find().count()} left."
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
      Chargers.remove({})

    describe "creates initial harness", ->
      beforeEach ->
        @actual_count = Chargers.find().count()

      it "has one or more documents", ->
        expect(@actual_count).not.to.equal(0)

      it "really has one document", ->
        expect(@actual_count).to.equal(1)

      it "has a document for Flagstaff", ->
        expect(Chargers.find({name: "Test Flagstaff, AZ"}).count()).to.equal(1)
