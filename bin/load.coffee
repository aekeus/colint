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

#nb = new classify.NaiveBayes classify.splitters.simple, false

#for line in lines
#  nb.train line[0], line[1]

#console.log nb.classifications argv.document

nb = new classify.Fisher classify.splitters.simple, false

for line in lines
  nb.train line[0], line[1]

console.log nb.classifications argv.document
