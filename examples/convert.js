fs = require 'fs'

lines = JSON.parse fs.readFileSync 'decision.json', 'utf-8'

results = []
for line in lines
  results.push
    referrer: line[0]
    location: line[1]
    read_faq: line[2] is 'yes'
    pages: line[3]
    service: line[4]

console.log JSON.stringify results
