#!/usr/bin/env coffee

util = require 'util'

args = require('optimist')
  .demand('count')
  .demand('dimensions')
  .default('low', 0)
  .default('high', 1)
  .argv

r = -> Math.random() * (args.high - args.low) + args.low

vectors = ([0...args.dimensions].map((d) -> r()) for v in [0...args.count])

console.log util.inspect vectors,
  maxArrayLength: null
