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

module.exports =
  euclidean: euclidean
  manhattan: manhattan
  supremum: supremum

