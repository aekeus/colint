#!/usr/bin/env coffee

tap = require('tap')
distance = require '../lib/distance'

tap.test (t) =>
  t.equal distance.euclidean([5], [1]), 4, 'single attribute euclidean'
  t.equal distance.euclidean([0, 0], [3, 4]), 5, 'two attributes euclidean'

  t.equal distance.manhattan([5], [1]), 4, 'single attribute manhattan'
  t.equal distance.manhattan([0, 0], [3, 4]), 7, 'two attributes manhattan'

  t.equal distance.supremum([5], [1]), 4, 'single attribute supremum'
  t.equal distance.supremum([0, 0], [3, 4]), 4, 'two attributes supremum'

  t.equal distance.smc([0], [0]), 1, 'one matching entry'
  t.equal distance.smc([1], [0]), 0, 'zero matching entry'

  t.equal distance.smc([0, 1], [0, 0]), 0.5, 'one matching entry of two'
  t.equal distance.smc([1, 0], [1, 0]), 1, 'two matching entries of two'

  t.equal distance.jaccard([0, 1, 1], [0, 0, 1]), 0.5, "one positive of three"
  t.equal distance.jaccard([0, 1, 1, 1], [0, 0, 1, 0]), 1 / 3, "one positive of three"

  t.equal distance.jaccard([0, 0], [0, 0]), 0, "zero if no matches"

  v1 = [3, 2, 0, 5, 0, 0, 0, 2, 0, 0]
  v2 = [1, 0, 0, 0, 0, 0, 0, 1, 0, 2]

  t.equal Math.round(distance.cosine(v1, v2) * 100), 31, 'cosine'

  t.equal Math.round(distance.ejaccard(v1, v2) * 1000), 116, 'ejaccard'

  t.equal distance.sq(distance.euclidean)([0,0], [3,4]), 25, 'squared distance'

  t.end()
