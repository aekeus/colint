#!/usr/bin/env coffee

fs = require 'fs'
_ = require 'underscore'

pageRank = require('../lib/page-rank').pageRank
utils = require '../lib/utils'

args = require('optimist')
  .demand(['inputFile'])
  .default('iterations', 100)
  .default('damping', 0.85)
  .default('deltaLimit', 0.0002)
  .argv

if not fs.existsSync args.inputFile
  console.log args.inputFile + ' does not exist'
  process.exit 1

endorsements = JSON.parse fs.readFileSync args.inputFile, 'utf-8'
nodes = _.keys endorsements

config =
  allNodes: -> nodes
  endorsements: (node) -> endorsements[node]
  iterationCount: -> args.iterations
  damping: -> args.damping
  deltaLimit: -> args.deltaLimit

pr = pageRank config

console.log JSON.stringify pr, null, 2
