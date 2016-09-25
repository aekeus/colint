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

  t.same utils.vectorScalarMult(v1, 2), [6, 4, 0, 10, 0, 0, 0, 4, 0, 0], 'vectorScalarMult'

  t.same utils.zip([1, 2, 3], [4, 5, 6]), [ [ 1, 4 ], [ 2, 5 ], [ 3, 6 ] ], 'zip'

  t.same utils.vectorAdd([1, 2, 3], [4, 5, 6]), [5, 7, 9], 'vectorAdd'

  t.same utils.vectorSubtract([1, 2, 3], [4, 5, 6]), [-3, -3, -3], 'vectorSubtract'

  t.same utils.vectorSum([[1, 2, 3], [4, 5, 6], [7, 8, 9]]), [12, 15, 18], 'vectorSum'

  t.same utils.vectorMean([[1, 2, 3], [4, 5, 6], [7, 8, 9]]), [4, 5, 6], 'vectorMean'

  t.end()
