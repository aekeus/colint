utils = require './utils'
distance = require './distance'

# Event builders for reporter
# 
iterationStartEvent = (iteration) ->
  o =
    type: 'iterationStart'
    iteration: iteration

iterationCompleteEvent = (iteration, means, assignments, error) ->
  o =
    type: 'iterationEnd'
    iteration: iteration
    means: means
    assignments: assignments
    error: error

#
# kmeans(Object, Function) -> Object
# 
kmeans = (opts, reporter) =>

  # If a message handler is not passed provide a default noop handler
  reporter or= ->

  # Retrieve parameters from opts
  vectors = opts.all()
  distanceMeasure = opts.distance()
  k = opts.k()

  # Pull k vectors as starting means
  means = utils.sample vectors, k

  #
  # classify(Array[Number]) -> Number
  #
  # Return the index of the closest mean
  # 
  classify = (v) ->
    distances = ([idx, distanceMeasure(v, cluster)] for cluster, idx in means)
    distances = distances.sort (a, b) -> a[1] - b[1]
    distances[0][0]

  #
  # totalError -> Number
  #
  # Return the sum of distances between means and their associated vectors
  # 
  totalError = ->
    error = 0
    for assignment, idx in assignments
      error += distanceMeasure means[assignment], vectors[idx]
    error
      
  # Complete model to be returned
  model =
    classify: classify
    clusters: -> means
    assignments: -> assignments
    totalError: totalError
      
  # Initialize the set of vector assignments to starting values
  assignments = (-1 for v, i in vectors)

  # Iterate until the assignments stop changing
  iteration = 1
  while true
    reporter iterationStartEvent iteration

    # Build a new set of assignments based on the current
    # position of the k means
    newAssignments = vectors.map classify

    # return the model if the assignments have not changed
    if distanceMeasure(assignments, newAssignments) is 0
      return model

    # Swap the assignments
    assignments = newAssignments

    # For each cluster
    for i in [0...k]
      # Pull assigned vectors for a cluster
      iVectors = (vectors[idx] for vector, idx in vectors when assignments[idx] is i)

      # If there are assigned vectors
      if iVectors.length
        # Update the values in the cluster
        means[i] = utils.vectorMean iVectors

    # Report iteration completion
    reporter iterationCompleteEvent iteration, means, assignments, totalError()

    iteration += 1

module.exports.kmeans = kmeans
