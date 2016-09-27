#!/usr/bin/env coffee

_ = require 'underscore'
fs = require 'fs'
PDF = require 'pdfkit'

kmeans = require('../lib/cluster').kmeans
utils = require '../lib/utils'
distance = require '../lib/distance'

args = require('optimist')
  .default('outputFile', 'cluster.pdf')
  .demand('inputFile')
  .demand('k')
  .argv

if not fs.existsSync args.inputFile
  console.log args.inputFile + ' does not exist'
  process.exit 1

doc = new PDF

vectors = JSON.parse(require('fs').readFileSync(args.inputFile))

test =
  all: -> vectors
  distance: -> distance.sq distance.euclidean
  k: -> args.k

model = kmeans test, (evt) -> console.log evt

means = model.clusters()

assignments = model.assignments()

colours = (idx) ->
  c = ["#3366cc", "#dc3912", "#ff9900", "#109618", "#990099", "#0099c6", "#dd4477", "#66aa00", "#b82e2e", "#316395", "#994499", "#22aa99", "#aaaa11", "#6633cc", "#e67300", "#8b0707", "#651067", "#329262", "#5574a6", "#3b3eac"]
  c[idx % c.length]

size = 600

for vector, idx in vectors
  doc
    .circle(parseInt(vector[0] * size), parseInt(vector[1] * size), 4)
    .lineWidth(1)
    .fillOpacity(0.8)
    .fillAndStroke(colours(assignments[idx]), colours(assignments[idx]))

for vector, idx in means
  doc
    .circle(parseInt(vector[0] * size), parseInt(vector[1] * size), 6)
    .lineWidth(2)
    .fillOpacity(0.8)
    .fillAndStroke(colours(idx), 'black')  

doc.pipe require('fs').createWriteStream(args.outputFile)
doc.end()

console.log "#{args.outputFile} created"
