_ = require 'underscore'
utils = require '../lib/utils'

euclidean = (v1, v2) =>
  return null if v1.length isnt v2.length
  accum = 0
  for v, idx in v1
    accum += Math.pow(v1[idx] - v2[idx], 2)
  Math.sqrt accum

manhattan = (v1, v2) =>
  return null if v1.length isnt v2.length
  accum = 0
  for v, idx in v1
    accum += Math.abs(v1[idx] - v2[idx])
  accum

supremum = (v1, v2) =>
  return null if v1.length isnt v2.length
  max = 0
  for v, idx in v1
    delta = Math.abs(v1[idx] - v2[idx])
    max = delta if delta > max
  max

smc = (v1, v2) =>
  return null if v1.length isnt v2.length
  return undefined if v1.length is 0
  c = 0
  for v, idx in v1
    c += 1 if v1[idx] is v2[idx]
  c / v1.length

jaccard = (v1, v2) =>
  return null if v1.length isnt v2.length
  return undefined if v1.length is 0
  c = 0
  d = 0
  for v, idx in v1
    c += 1 if v1[idx] and (v1[idx] is v2[idx])
    d += 1 if v1[idx] or v2[idx]
  return 0 if d is 0
  c / d

ejaccard = (v1, v2) => utils.dot(v1, v2) / (Math.pow(utils.magnitude(v1), 2) + Math.pow(utils.magnitude(v2), 2) - utils.dot(v1, v2))

cosine = (v1, v2) => utils.dot(v1, v2) / (utils.magnitude(v1) * utils.magnitude(v2))

module.exports =
  euclidean: euclidean
  manhattan: manhattan
  supremum: supremum
  smc: smc
  jaccard: jaccard
  cosine: cosine
  ejaccard: ejaccard
