utils = require './utils'

class Recommender
  constructor: ->
    @items = {}
    @people = {}
    @ratings = {}

  add_item: (item) ->
    throw "item exists" if @items[item.id]
    @items[item.id] = item

  add_person: (person) ->
    throw "person exists" if @people[person.id]
    @people[person.id] = person

  add_rating: (person_id, item_id, rating) ->
    throw "item does not exist" unless @items?[item_id]
    throw "person does not exist" unless @people?[person_id]

    if not @ratings?[person_id]
      @ratings[person_id] = {}
    @ratings[person_id][item_id] = rating

  pearson: (p1, p2) ->
    mutual = []
    for item_id, rating of @ratings[p1]
      if @ratings[p2]?[item_id]
        mutual.push item_id
    mutual

    n = mutual.length
    return 0 if mutual.length is 0

    sum1 = utils.sum (@ratings[p1][i].rating for i in mutual)
    sum2 = utils.sum (@ratings[p2][i].rating for i in mutual)

    sum1sq = utils.sum (Math.pow(@ratings[p1][i].rating, 2) for i in mutual)
    sum2sq = utils.sum (Math.pow(@ratings[p2][i].rating, 2) for i in mutual)

    psum = utils.sum (@ratings[p1][i].rating * @ratings[p2][i].rating for i in mutual)

    num = psum - (sum1*sum2/n)
    den = Math.sqrt( ( sum1sq - (sum1*sum1) / n ) * ( sum2sq - (sum2*sum2) / n ) )

    return 0 if den is 0
    num / den

  person_sim: (person_id, n=5) ->
    compare_against = (k for k, _ of @people when k isnt person_id.toString())
    scores = ([pid, @pearson(person_id, pid)] for pid in compare_against)
    scores.sort (a, b) -> b[1] - a[1]
    scores[0..n-1]

  recommendations: (person_id, n=5) ->
    totals = {}
    sim_sums = {}
    for other_id, _ of @people when other_id isnt person_id
      sim = @pearson(person_id, other_id)
      if sim >= 0
        for item_id, _ of @ratings[other_id]
          if not @ratings[person_id]?[item_id]
            totals[item_id] = 0 if not totals?[item_id]
            totals[item_id] += sim * @ratings[other_id][item_id].rating
            sim_sums[item_id] = 0 if not sim_sums?[item_id]
            sim_sums[item_id] += sim

    rankings = ([item_id, total / sim_sums[item_id]] for item_id, total of totals)
    rankings.sort (a, b) -> b[1] - a[1]
    rankings[0..n]

  # transpose the people and item ids and return a new recommender
  flip: ->
    new_ratings = {}
    for person_id, _ of @people
      for item_id, _ of @items
        new_ratings[item_id] = {} if not new_ratings?[item_id]
        new_ratings[item_id][person_id] = @ratings[person_id][item_id] if @ratings?[person_id]?[item_id]

    new_recommender = new Recommender()
    new_recommender.people = @items
    new_recommender.items = @people
    new_recommender.ratings = new_ratings

    new_recommender

exports.Recommender = Recommender
