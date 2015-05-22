# examples used from Chapter 7 of Collective Intelligence, Toby Segaran 2007

fs = require 'fs'
dt = require '../lib/decisiontree'

rows = JSON.parse fs.readFileSync 'web-behaviour.json', 'utf-8'

[s1, s2] = dt.divide rows, 'read_faq', true

console.log dt.gini rows, 'service'
console.log dt.entropy rows, 'service'
console.log dt.entropy s1, 'service'
console.log dt.gini s2, 'service'

tree = dt.build_tree rows, 'service', dt.entropy

tree.draw()

console.log tree.classify
  referrer: '(direct)'
  location: 'USA'
  read_faq: true
  pages: 5

t = dt.build_tree rows, 'referrer', dt.entropy
t.draw()

console.log t.classify
  service: 'None'
  location: 'USA'
  read_faq: true
  pages: 5
