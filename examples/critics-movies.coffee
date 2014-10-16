# examples used from Chapter 2 of Collective Intelligence, Toby Segaran 2007

Recommender = require('../lib/recommend').Recommender

#  id: 1
#  name: "Lisa Rose"
#
#  id: 2
#  name: "Gene Seymour"
#
#  id: 3
#  name: "Michael Phillips"
#
#  id: 4
#  name: "Claudia Puig"
#
#  id: 5
#  name: "Mick LaSalle"
#
#  id: 6
#  name: "Jack Matthews"
#
#  id: 7
#  name: "Toby"

#  id: 100
#  name: "Lady in the Water"
#
#  id: 101
#  name: "Snakes on a Plane"
#
#  id: 102
#  name: "Just My Luck"
#
#  id: 103
#  name: "Superman Returns"
#
#  id: 104
#  name: "You, Me and Dupree"
#
#  id: 105
#  name: "The Night Listener"

r = new Recommender()

r.add_rating 1, 100, 2.5
r.add_rating 1, 101, 3.5
r.add_rating 1, 102, 3.0
r.add_rating 1, 103, 3.5
r.add_rating 1, 104, 2.5
r.add_rating 1, 105, 3.0

r.add_rating 2, 100, 3.0
r.add_rating 2, 101, 3.5
r.add_rating 2, 102, 1.5
r.add_rating 2, 103, 5.0
r.add_rating 2, 104, 3.5
r.add_rating 2, 105, 3.0

r.add_rating 3, 100, 2.5
r.add_rating 3, 101, 3.0
r.add_rating 3, 103, 3.5
r.add_rating 3, 105, 4.0

r.add_rating 4, 101, 3.5
r.add_rating 4, 102, 3.0
r.add_rating 4, 105, 4.5
r.add_rating 4, 103, 4.0
r.add_rating 4, 104, 2.5

r.add_rating 5, 100, 3.0
r.add_rating 5, 101, 4.0
r.add_rating 5, 102, 2.0
r.add_rating 5, 103, 3.0
r.add_rating 5, 104, 2.0
r.add_rating 5, 105, 3.0

r.add_rating 6, 100, 3.0
r.add_rating 6, 101, 4.0
r.add_rating 6, 105, 3.0
r.add_rating 6, 103, 5.0
r.add_rating 6, 104, 3.5

r.add_rating 7, 101, 4.5
r.add_rating 7, 104, 1.0
r.add_rating 7, 103, 4.0

console.log r.pearson("1", "2")
console.log r.top_matches "7", 5, r.pearson
console.log r.recommendations "7"

flipper = r.flip()
console.log flipper.top_matches "103", 5, r.pearson

item_sims = r.similar_items 5, r.distance
console.log item_sims

console.log r.item_recommendations item_sims, '7'
