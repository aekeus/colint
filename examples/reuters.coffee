# dataset retrieve from https://archive.ics.uci.edu/ml/datasets/Reuters-21578+Text+Categorization+Collection

argv = require('optimist')
  .demand(['text'])
  .argv

fs = require 'fs'
xml2js = require('xml2js')

classify = require('../lib/classify')
nb = new classify.NaiveBayes(classify.splitters.simple)

contents = fs.readFileSync 'reut2-000.sgm', 'utf-8'

parser = new xml2js.Parser
  explicitArray: false
  
parser.parseString contents, (err, xml) ->
  for story in xml.CONTENTS.REUTERS
    if story.$.TOPICS isnt 'NO'
      if typeof story.TOPICS.D is 'string'
        topics = [story.TOPICS.D]
      else
        topics = story.TOPICS.D

      if topics? and topics.length and story.TEXT.BODY
        for topic in topics
          nb.train story.TEXT.BODY, topic

  console.log "DOCUMENTS = #{nb.doc_count()}"
  console.log nb.classifications argv.text
