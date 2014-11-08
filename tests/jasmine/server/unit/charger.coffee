describe "Chargers", ->
  describe "Insert/Update", ->

    it "should be created with a name", ->
      spyOn(Chargers, "update").and.callFake (doc, callback) ->
        callback(null, 1)

      charger = new Charger
        id: 99399
        name: "Silverthorne, CO"

      # Meteor.methodMap.parseChargerData [{
      #   id: 999399
      #   name: "Silverthorne, CO"
      #   }]

      expect(Chargers.update).toHaveBeenCalledWith[[
        {
          id: 999399
          name: "Silverthorne, CO"
        }
      ]]

# describe "Chargers", ->
#   describe "Insert/Update", ->

#     it "should be created with a name", ->
#       spyOn(Chargers, "update").and.returnValue 1

#       Meteor.methodMap.parseChargerData [{
#         id: 999399
#         name: "Silverthorne, CO"
#         }]

#       expect(Chargers.update).toHaveBeenCalledWith[[
#         {
#           id: 999399
#           name: "Silverthorne, CO"
#         },
#         {},
#         {
#           upsert: true
#         }
#       ]]
