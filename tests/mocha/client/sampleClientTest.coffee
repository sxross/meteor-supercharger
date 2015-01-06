expect = chai.expect

unless typeof MochaWeb is 'undefined'
  MochaWeb.testOnly ->
    describe "a group of tests", ->
      it 'respects equality', ->
        expect(5).to.equal(5)
