exports.sum = (lst) ->
  s = 0
  s += v for v in lst
  s

exports.dot = dot = (v1, v2) =>
  return 0 if v1.length is 0
  sum = 0
  for v, idx in v1
    sum += v1[idx] * v2[idx]
  sum

exports.magnitude = (v1) => Math.sqrt(dot(v1, v1))

exports.tanimoto = (lst1, lst2) ->
  intersection = (x for x in lst1 when lst2.indexOf(x) isnt -1)
  intersection.length / (lst1.length + lst2.length - intersection.length)
