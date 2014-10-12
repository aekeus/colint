exports.tanimoto = (lst1, lst2) ->
  intersection = (x for x in lst1 when lst2.indexOf(x) isnt -1)
  intersection.length / (lst1.length + lst2.length - intersection.length)

console.log exports.tanimoto [1,2,3], [2,3,4,5]
