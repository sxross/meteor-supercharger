# MochaWeb?.testOnly ->
#   describe "Increment/Decrement", ->
#     beforeEach ->
#
#     describe "an empty database", ->
#       it "shows a message that there are no chargers", ->
#         no_chargers = jQuery('.jumbotron > h2')
#         expect(no_chargers.text()).to.match(/don't see any superchargers/i)
#
#     describe "populating a database", ->
#
#       it "increments Tesla count", ->
#         doc = new ChargerServerDoc  {
#           "id": 600,
#           "name": "Someplace, AZ",
#           "status": "OPEN",
#           "address": {
#             "street": "416 S Noplace RD",
#             "city": "Whoknows",
#             "state": "AZ",
#             "zip": "85326",
#             "country": "USA"
#           },
#           "gps": {
#             "latitude": 33.443011,
#             "longitude": -112.556876
#           },
#           "elevationMeters": 338,
#           "url": "http:\/\/www.teslamotors.com\/supercharger\/buckeye",
#           "urlDiscuss": "http:\/\/www.teslamotorsclub.com\/showthread.php\/25317-Supercharger-Buckeye-AZ",
#           "stallCount": 10,
#           "counted": true,
#           "dateOpened": "2014-03-20"
#           teslaCount: 0
#           iceCount: 0
#           lineCount: 0
#           offlineCount: 0
#         }
#
#
#
#         doc.set_defaults().merge().needs_update
#           insert: (doc) ->
#             console.log "inserting #{doc}"
#             Chargers.insert(doc)
#           update: (id, doc) ->
#             console.log "presumably updating #{id}, #{doc}"
#
#         expect(Chargers.find().count()).to.equal(1)
