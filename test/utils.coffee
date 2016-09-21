#!/usr/bin/env coffee

tap = require('tap')
utils = require '../lib/utils'

tap.test (t) =>
  t.equal utils.dot([3, 2, 0, 5, 0, 0, 0, 2, 0, 0], [1, 0, 0, 0, 0, 0, 0, 1, 0, 2]), 5, 'dot product'

  t.end()
