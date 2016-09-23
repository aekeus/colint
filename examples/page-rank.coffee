_ = require 'underscore'
pageRank = require '../lib/page-rank'

config =
  allNodes: => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  endorsements: (node) =>
    o =
      0: [1, 2],
      1: [0, 2, 3],
      2: [0, 1, 3],
      3: [4],
      4: [],
      5: [6, 4],
      6: [8],
      7: [5],
      8: [7, 9],
      9: []
    o[node]

config = _.extend(config, pageRank.defaultConfiguration)

events = []
reporter = (evt) ->
  events.push evt

console.log pageRank.pageRank config, reporter
console.log events.length
