_ = require 'underscore'
distance = require './distance'

# Build an object containing the node identifier and some page rank
initPageRank = (nodes, func) => _.object([node, func()] for node in nodes)

# Retrieve page ranks as vector
vectorForm = (pr) -> (v for k, v of pr)

# Event builders for reporter
# 
donationEvent = (source, destination, amount) ->
  o =
    type: 'donation'
    source: source
    destination: destination
    amount: amount

iterationCompleteEvent = (iterationNumber, delta, pageRank) ->
  o =
    type: 'iterationComplete'
    iterationNumber: iterationNumber
    delta: delta
    pageRank: pageRank

iterationStartEvent = (iterationNumber) ->
  o =
    type: 'iterationStart'
    iterationNumber: iterationNumber

#
# pageRank(Object, Function) -> Object
#
module.exports.pageRank = pageRank = (opts, reporter) =>

  # If a message handler is not passed provide a default noop handler
  reporter or= () ->

  # Retrieve a list of all nodes
  all = opts.allNodes()
  N = all.length
  
  # Build initial page rank structure
  currentPR = initPageRank all, -> 1 / N

  # For a maximum number of iterations
  for x in [0...opts.iterationCount()]

    # Report the start of an iteration
    reporter iterationStartEvent x

    # Build new page rank for iteration
    nextPR = initPageRank all, -> 0

    # Each node gives a fraction of the total page rank each iteration
    basePR = (1 - opts.damping())

    # Distribute page rank from each node's endorsements
    for node in all

      # Amount of page rank to distribute 
      linkPRToDistribute = currentPR[node] * opts.damping()

      # Array of endorsements
      endorsements = opts.endorsements node

      # If there are endorsements
      if endorsements.length
        # Distribute the node's page rank evenly to endorsed nodes
        for endorsement in endorsements
          amount = linkPRToDistribute / endorsements.length
          nextPR[endorsement] += amount
          reporter donationEvent node, endorsement, amount
      # No endorsements for this node
      else
        # Distribute the node's page rank to all nodes evenly
        for n in all when n isnt node
          amount = linkPRToDistribute / (N - 1)
          nextPR[n] += amount
          reporter donationEvent node, n, amount

    # Each node receives a fraction of the total page rank each iteration
    nextPR[n] += basePR / N for n in all

    # Calculate how close the page rank graph is from the previous iteration
    delta = distance.euclidean vectorForm(currentPR), vectorForm(nextPR)

    # Report on the complete iteration
    reporter iterationCompleteEvent x, delta, _.clone(nextPR)

    # If the iteration page ranks are close enough, exit early
    if delta < opts.deltaLimit()
      return nextPR

    # Make the working page rank the current page rank
    currentPR = nextPR

  # Return if iteration limited exceeded
  nextPR

module.exports.defaultConfiguration = defaultConfiguration =
  damping: => 0.85
  iterationCount: => 100
  deltaLimit: => 0.0002

