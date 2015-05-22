utils = require './utils'

class Recommender
  constructor: ->
    @ratings = {}

  all_people: ->
    ids = {}
    ids[person_id] = true for person_id, _ of @ratings
    (person_id for person_id, _ of ids)

  all_items: ->
    ids = {}
    for person_id, _ of @ratings
      ids[item_id] = true for item_id, _ of @ratings[person_id]
    (person_id for person_id, _ of ids)

  add_rating: (person_id, item_id, rating) ->
    if not @ratings?[person_id]
      @ratings[person_id] = {}
    @ratings[person_id][item_id] = rating

  mutual: (p1, p2) ->
    mutual = []
    for item_id, rating of @ratings[p1]
      if @ratings[p2]?[item_id]
        mutual.push item_id
    mutual

  distance: (p1, p2) ->
    mutual = @mutual p1, p2    
    n = mutual.length
    return 0 if mutual.length is 0

    sum_of_squares = utils.sum (Math.pow(@ratings[p1][item_id] - @ratings[p2][item_id], 2) for item_id, _ of @ratings[p1] when @ratings[p2]?[item_id])

    1 / (1 + sum_of_squares)
    
  pearson: (p1, p2) ->
    mutual = @mutual p1, p2
    n = mutual.length
    return 0 if mutual.length is 0

    sum1 = utils.sum (@ratings[p1][i] for i in mutual)
    sum2 = utils.sum (@ratings[p2][i] for i in mutual)

    sum1sq = utils.sum (Math.pow(@ratings[p1][i], 2) for i in mutual)
    sum2sq = utils.sum (Math.pow(@ratings[p2][i], 2) for i in mutual)

    psum = utils.sum (@ratings[p1][i] * @ratings[p2][i] for i in mutual)

    num = psum - (sum1 * sum2 / n)
    den = Math.sqrt( ( sum1sq - (sum1 * sum1) / n ) * ( sum2sq - (sum2 * sum2) / n ) )

    return 0 if den is 0
    num / den

  top_matches: (person_id, n=5, method) ->
    compare_against = (k for k in @all_people() when k isnt person_id.toString())
    scores = ([pid, method.call(@, person_id, pid)] for pid in compare_against)
    scores.sort (a, b) -> b[1] - a[1]
    scores[0..n-1]

  recommendations: (person_id, n = 5) ->
    totals = {}
    sim_sums = {}
    for other_id in @all_people() when other_id isnt person_id
      sim = @pearson(person_id, other_id)
      if sim > 0
        for item_id, _ of @ratings[other_id]
          if not @ratings[person_id]?[item_id]
            totals[item_id] = 0 if not totals?[item_id]
            totals[item_id] += sim * @ratings[other_id][item_id]
            sim_sums[item_id] = 0 if not sim_sums?[item_id]
            sim_sums[item_id] += sim

    rankings = ([item_id, total / sim_sums[item_id]] for item_id, total of totals)
    rankings.sort (a, b) -> b[1] - a[1]
    rankings[0..n]

  similar_items: (n = 5, method=@pearson) ->
    flipped = @flip()
    
    results = {}
    for id in flipped.all_people()
      scores = flipped.top_matches(id, n, method)
      results[id] = scores

    results

  item_recommendations: (item_sims, person_id) ->
    user_ratings = @ratings[person_id]
    scores = {}
    total_sim = {}

    for item_id, rating of user_ratings
      for [item_id_2, similarity] in item_sims[item_id]

        if not user_ratings?[item_id_2]
          scores[item_id_2] = 0 unless scores?[item_id_2]
          scores[item_id_2] += similarity * rating
          total_sim[item_id_2] =0 unless total_sim?[item_id_2]
          total_sim[item_id_2] += similarity

    rankings = ([item, score / total_sim[item]] for item, score of scores)

    rankings.sort (a, b) -> b[1] > a[1]
    rankings
      
  # transpose the people and item ids and return a new recommender
  flip: ->
    new_ratings = {}
    for person_id in @all_people()
      for item_id in @all_items()
        new_ratings[item_id] = {} if not new_ratings?[item_id]
        if @ratings?[person_id]?[item_id]
          new_ratings[item_id][person_id] = @ratings[person_id][item_id] 

    new_recommender = new Recommender()
    new_recommender.ratings = new_ratings

    new_recommender

exports.Recommender = Recommender
