#!/usr/bin/env coffee

tap = require('tap')
distance = require '../lib/distance'

tap.test (t) =>
  t.ok distance.euclidean, 'euclidean defined'
  t.equal distance.euclidean([5], [1]), 4, 'single attribute euclidean'
  t.equal distance.euclidean([0, 0], [3, 4]), 5, 'two attributes euclidean'

  t.equal distance.manhattan([5], [1]), 4, 'single attribute manhattan'
  t.equal distance.manhattan([0, 0], [3, 4]), 7, 'two attributes manhattan'

  t.equal distance.supremum([5], [1]), 4, 'single attribute supremum'
  t.equal distance.supremum([0, 0], [3, 4]), 4, 'two attributes supremum'

  t.end()
