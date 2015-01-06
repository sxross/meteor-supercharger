MochaWeb?.testOnly ->
  expect = chai.expect

  describe "charger document", ->
    beforeEach ->
      @their_copy =
        "id": 601,
        "name": "Test Flagstaff, AZ",
        "status": "CONSTRUCTION",
        "address": {
          "street": "2650 S Beulah Blvd",
          "city": "Flagstaff",
          "state": "AZ",
          "zip": "86001",
          "country": "USA"
        }
        "stallCount": 8
      @our_copy = JSON.parse JSON.stringify(@their_copy)
      @their_copy.status     = 'OPEN'
      @their_copy._id        = 'GzzyZx303'
      @their_copy.bogus_key  = 'bogus'
      @our_copy.teslaCount   = 1
      @our_copy.lineCount    = 2


    it 'creates a charger server document', ->
      expect(new ChargerServerDoc(our_copy, their_copy)).to.be.an.instanceof(ChargerServerDoc)

    describe 'setting defaults', ->
      beforeEach ->
        @doc = new ChargerServerDoc(our_copy, their_copy)

      it 'returns another ChargerServerDoc', ->
        expect(@doc.set_defaults()).to.be.an.instanceof(ChargerServerDoc)

      it 'leaves values on our copy alone, filling in when not present', ->
        @doc.set_defaults()
        expect(@doc.working_document).to.be.an.instanceof(Object)
        expect(@doc.working_document.teslaCount).to.equal(1)
        expect(@doc.working_document.lineCount).to.equal(2)
        expect(@doc.working_document.iceCount).to.equal(0)
        expect(@doc.working_document.offlineCount).to.equal(0)

      it 'handles null values', ->
        @doc.set_defaults()
        @doc.retrieved_document = null
        data = @doc.get()
        expect(data).to.deep.equal(our_copy)

    describe 'merging retrieved and working documents', ->
      beforeEach ->
        @doc = new ChargerServerDoc(our_copy, their_copy)

      it 'returns a ChargerServerDoc', ->
        expect(@doc.merge()).to.be.an.instanceof(ChargerServerDoc)

      it 'copies fields over properly', ->
        @doc.merge()
        expect(@doc.get()).to.include.keys('status', 'bogus_key')
        expect(@doc.get().status).to.equal('OPEN')

      it 'leaves protected fields alone on merge', ->
        @doc.merge()
        expect(@doc.get().teslaCount).to.equal(1)
        expect(@doc.get().lineCount).to.equal(2)

      it 'updates core fields even if present in both', ->
        @their_copy.stallCount = 10
        expect(@their_copy.stallCount).not.to.equal(@our_copy.stallCount)
        doc = new ChargerServerDoc(@our_copy, @their_copy)
        doc.merge()
        expect(doc.get().stallCount).to.equal(@our_copy.stallCount)

    describe 'equality', ->
      it 'understands equality of documents', ->
        @doc = new ChargerServerDoc(@our_copy, @our_copy)
        expect(@doc.is_equal()).to.equal(true)

      it 'understands inequality between documents', ->
        mine = JSON.parse JSON.stringify(@our_copy)
        theirs = JSON.parse JSON.stringify(@our_copy)
        theirs.stallCount += 2
        @doc = new ChargerServerDoc(@our_copy, @their_copy)
        expect(@doc.is_equal()).to.equal(false)

    describe 'update requirement', ->
      beforeEach ->
        spies.restoreAll()

      it 'knows when a document pair indicates an update requirement', ->
        @doc = new ChargerServerDoc(@our_copy, @their_copy)
        expect(@doc.needs_update()).to.equal(true)

      it 'calls update spy when both documents are present but different', ->
        @doc = new ChargerServerDoc(@our_copy, @their_copy)
        update_spy = spies.create('update')
        insert_spy = spies.create('insert')
        @doc.set_defaults().merge().needs_update
          update: update_spy
          insert: insert_spy

        expect(spies.update).to.have.been.called
        expect(spies.insert).not.to.have.been.called

      it 'calls insert when only one document is present', ->
        @doc = new ChargerServerDoc(@our_copy)
        update_spy = spies.create('update')
        insert_spy = spies.create('insert')
        @doc.set_defaults().merge().needs_update
          update: update_spy
          insert: insert_spy

        expect(spies.update).not.to.have.been.called
        expect(spies.insert).to.have.been.called

      it 'calls insert with one argument of string type', ->
        @doc = new ChargerServerDoc(@our_copy)
        update_spy = spies.create('update')
        insert_spy = spies.create('insert')
        @doc.set_defaults().merge().needs_update
          update: update_spy
          insert: insert_spy
        expect(spies.insert).to.have.been.calledWith(@our_copy)


      it 'calls update with two arguments of string and object type', ->
        @doc = new ChargerServerDoc(@our_copy, @their_copy)
        update_spy = spies.create('update')
        insert_spy = spies.create('insert')
        @doc.set_defaults().merge().needs_update
          update: update_spy
          insert: insert_spy

        expected = _.omit(@their_copy, "_id")
        expected.teslaCount = @our_copy.teslaCount
        expected.iceCount = @our_copy.iceCount
        expected.lineCount = @our_copy.lineCount
        expected.offlineCount = @our_copy.offlineCount

        expect(spies.update).to.have.been.calledWith(@their_copy._id, expected)
