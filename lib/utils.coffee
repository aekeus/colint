_ = require 'underscore'

exports.sum = (lst) ->
  s = 0
  s += v for v in lst
  s

#
# dot(Array[Number], Array[Number]) -> Number
#
# Return the dot product of two equal length vectors
#
exports.dot = dot = (v1, v2) =>
  return 0 if v1.length is 0
  sum = 0
  sum += v1[idx] * v2[idx] for v, idx in v1
  sum

#
# magnitude(Array[Number]) -> Number
#
# Return the euclidean distance from the origin to the
# vector.
#
exports.magnitude = (v1) => Math.sqrt(dot(v1, v1))

#
# normalize(Array[Number], Number, Number) -> [Array[Number], Function]
#
# Return a normalized array and a function that when applied will
# reverse the normalization.
#
exports.normalize = (vector, min=0, max=1) =>
  outputRange = max - min

  minimum = _.min vector
  maximum = _.max vector
  range = maximum - minimum

  normalized = vector.map (v) => ((v - minimum) / range) * outputRange + min
  remapper = (nVec) => nVec.map (v) => ((v - min) / outputRange) * range + minimum

  [normalized, remapper]

#
# vectorScalarMult(Array[Number], Number) -> Array[Number]
#
exports.vectorScalarMult = (vector, scalar) -> (x * scalar for x in vector)

#
# vectorAdd(Array[Number], Array[Number]) -> Array[Number]
#
exports.vectorAdd = (v1, v2) -> (v1[idx] + v2[idx] for v, idx in zip(v1, v2))

#
# vectorSubtract(Array[Number], Array[Number]) -> Array[Number]
#
exports.vectorSubtract = (v1, v2) -> (v1[idx] - v2[idx] for v, idx in zip(v1, v2))

#
# vectorSum(Array[Array[Number]]) -> Array[Number]
#
exports.vectorSum = (vectors) -> _.reduce vectors, exports.vectorAdd

#
# vectorMean(Array[Array[Number]]) -> Array[Number]
#
exports.vectorMean = (vectors) ->
  exports.vectorScalarMult exports.vectorSum(vectors), 1 / vectors.length

#
# zip(Array[Number], Array[Number]) -> Array[Array[Number, Number]]
#
exports.zip = zip = (v1, v2) -> ([v1[idx], v2[idx]] for v, idx in v1)

exports.tanimoto = (lst1, lst2) ->
  intersection = (x for x in lst1 when lst2.indexOf(x) isnt -1)
  intersection.length / (lst1.length + lst2.length - intersection.length)
