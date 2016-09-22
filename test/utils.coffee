#!/usr/bin/env coffee

tap = require('tap')
utils = require '../lib/utils'

tap.test (t) =>
  v1 = [3, 2, 0, 5, 0, 0, 0, 2, 0, 0]
  v2 = [1, 0, 0, 0, 0, 0, 0, 1, 0, 2]

  t.equal utils.dot(v1, v2), 5, 'dot product'
  t.equal Math.round(utils.magnitude(v1) * 100), 648, 'magnitude'

  [vec, func] = utils.normalize v1, 0, 10
  t.same vec, [ 6, 4, 0, 10, 0, 0, 0, 4, 0, 0 ], 'normalization'
  t.same func(vec), v1, 'remapper'

  t.end()
