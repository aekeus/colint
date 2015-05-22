util = require 'util'
_ = require 'underscore'

class TreeNode
  constructor: (@column_name, @value, @results, @true_branch, @false_branch) ->

  draw: (indent='') =>
    if @results
      console.log JSON.stringify @results
    else
      console.log @column_name + ":" + @value + '? '
      process.stdout.write indent + 'T -> '
      @true_branch.draw indent + '  '
      process.stdout.write indent + 'F -> '
      @false_branch.draw indent + '  '

  classify: (observation) =>
    return @results if @results
    
    value = observation[@column_name]
    console.log @column_name + ":" + @value + " (" + value + ')'
    
    if _.isNumber value
      branch = if value >= @value then @true_branch else @false_branch
    else
      branch = if value is @value then @true_branch else @false_branch
      
    branch.classify observation
      
exports.TreeNode = TreeNode
    
#
# divide(Array[Object], String, Any) -> [Array[Object], Array[Object]]
#
# Divide array into two sets based on the attribute name and value
# 
exports.divide = divide = (rows, column_name, value) ->
  if _.isNumber value
    tester = (row) -> row[column_name] >= value
  else
    tester = (row) ->row[column_name] is value

  first_set = (row for row in rows when tester(row))
  second_set = (row for row in rows when not tester(row))

  [first_set, second_set]

#
# counts(Array[Object], String) -> Object
#
# return the count of unique values for a key in an array of objects
# 
exports.counts = (rows, column_name) ->
  _.object ([k, v.length] for k, v of _.groupBy(rows,column_name))

#
# gini(Array[Object], String) -> Float
#
# calculate the gini impurity of a set of values
# 
exports.gini = (rows, column_name) ->
  row_count = rows.length
  counts = exports.counts rows, column_name
  imp = 0
  for k1, v1 of counts
    p1 = v1 / row_count
    for k2, v2 of counts
      if k1 isnt k2
        p2 = v2 / row_count
        imp += p1 * p2
  imp

log2 = (x) -> Math.log(x) / Math.log(2)

#
# entropy(Array[Object], String) -> Float
#
# calculate the amount of entropy for an attribute in an array of objects
# 
exports.entropy = (rows, column_name) ->
  counts = exports.counts rows, column_name
  ent = 0
  for k, v of counts
    p = v / rows.length
    ent = ent - p * log2(p)
  ent

#
# build_tree(Array[Object], String, Function(Array[Object], String)) -> TreeNode
# 
# build a classification tree for a dataset on a specific column using an entropy scorer function
# 
exports.build_tree = build_tree = (rows, column_name, scorer) ->
  return new TreeNode() if rows.length is 0

  score = scorer rows, column_name

  best_gain = 0
  best_criteria = null
  best_sets = null

  for k, v of rows[0] when k isnt column_name
    column_values = _.uniq (row[k] for row in rows)
    for column_value in column_values
      [set1, set2] = divide rows, k, column_value
      p = set1.length / rows.length
      gain = score - p * scorer(set1, column_name) - (1 - p) * scorer(set2, column_name)
      if gain > best_gain
        console.log gain, k, column_value
        best_gain = gain
        best_criteria = [k, column_value]
        best_sets = [set1, set2]
        
  if best_gain > 0
    true_branch = build_tree best_sets[0], column_name, scorer
    false_branch = build_tree best_sets[1], column_name, scorer
    new TreeNode best_criteria[0], best_criteria[1], null, true_branch, false_branch
  else
    new TreeNode null, null, exports.counts(rows, column_name), null, null
