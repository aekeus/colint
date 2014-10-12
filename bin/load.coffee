fs = require 'fs'
classify = require '../lib/classify'
argv = require('optimist')
  .demand(['file', 'document'])
  .argv

lines = (fs.readFileSync argv.file, 'utf-8').split /\n/g
lines = (l.split('|') for l in lines when l isnt '')
for line in lines
  line[0] = line[0].trim()
  line[1] = line[1].trim().toLowerCase()

c = new classify.Classifier classify.splitters.simple
nb = new classify.NaiveBayes c

for line in lines
  c.train line[0], line[1]

console.log nb.classifications argv.document

