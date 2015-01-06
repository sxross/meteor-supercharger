MochaWeb?.testOnly ->
  describe "server initialization", ->
    it 'has a Meteor version number defined', ->
      chai.assert(Meteor.release)
