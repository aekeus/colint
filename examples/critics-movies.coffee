# examples used from Chapter 2 of Collective Intelligence, Toby Segaran 2007

Recommender = require('../lib/recommend').Recommender

r = new Recommender()

r.add_person
  id: 1
  name: "Lisa Rose"
  
r.add_person
  id: 2
  name: "Gene Seymour"
        
r.add_person
  id: 3
  name: "Michael Phillips"

r.add_person
  id: 4
  name: "Claudia Puig"

r.add_person
  id: 5
  name: "Mick LaSalle"

r.add_person
  id: 6
  name: "Jack Matthews"

r.add_person
  id: 7
  name: "Toby"

r.add_item
  id: 100
  name: "Lady in the Water"
  type: "movie"

r.add_item
  id: 101
  name: "Snakes on a Plane"
  type: "movie"

r.add_item
  id: 102
  name: "Just My Luck"
  type: "movie"

r.add_item
  id: 103
  name: "Superman Returns"
  type: "movie"

r.add_item
  id: 104
  name: "You, Me and Dupree"
  type: "movie"

r.add_item
  id: 105
  name: "The Night Listener"
  type: "movie"

r.add_rating 1, 100,
  rating: 2.5
r.add_rating 1, 101,
  rating: 3.5
r.add_rating 1, 102,
  rating: 3.0
r.add_rating 1, 103,
  rating: 3.5
r.add_rating 1, 104,
  rating: 2.5
r.add_rating 1, 105,
  rating: 3.0

r.add_rating 2, 100,
  rating: 3.0
r.add_rating 2, 101,
  rating: 3.5
r.add_rating 2, 102,
  rating: 1.5
r.add_rating 2, 103,
  rating: 5.0
r.add_rating 2, 104,
  rating: 3.5
r.add_rating 2, 105,
  rating: 3.0

r.add_rating 3, 100,
  rating: 2.5
r.add_rating 3, 101,
  rating: 3.0
r.add_rating 3, 103,
  rating: 3.5
r.add_rating 3, 105,
  rating:4.0

r.add_rating 4, 101,
  rating: 3.5
r.add_rating 4, 102,
  rating: 3.0
r.add_rating 4, 105,
  rating: 4.5
r.add_rating 4, 103,
  rating: 4
r.add_rating 4, 104,
  rating: 2.5

r.add_rating 5, 100,
  rating: 3.0
r.add_rating 5, 101,
  rating: 4.0
r.add_rating 5, 102,
  rating: 2.0
r.add_rating 5, 103,
  rating: 3.0
r.add_rating 5, 104,
  rating: 2.0
r.add_rating 5, 105,
  rating: 3.0

r.add_rating 6, 100,
  rating: 3.0
r.add_rating 6, 101,
  rating: 4.0
r.add_rating 6, 105,
  rating: 3.0
r.add_rating 6, 103,
  rating: 5.0
r.add_rating 6, 104,
  rating: 3.5

r.add_rating 7, 101,
  rating: 4.5
r.add_rating 7, 104,
  rating: 1.0
r.add_rating 7, 103,
  rating: 4.0

console.log r.pearson("1", "2")
console.log r.person_sim "7"
console.log r.recommendations "7"

flipper = r.flip()
console.log flipper.person_sim "103"
