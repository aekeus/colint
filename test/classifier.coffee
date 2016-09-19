#!/usr/bin/env coffee

test = require('tap').test
classify = require '../lib/classify'

test "simple splitter", (t) ->
  results = classify.splitters.simple "I came, I saw, I conquered"
  results.sort()

  t.deepEqual results, ['came', 'conquered', 'i', 'saw'], "keep stop words"

  results = classify.splitters.simple "I came, I saw, I conquered", { remove_stop_words: true }
  results.sort()

  t.deepEqual results, ['came', 'conquered', 'saw'], "remove stop words"

  t.end()

test "general classifier methods", (t) ->
  t.ok classify.splitters, "has splitter"
  t.ok classify.splitters.simple, "has simple splitter"
  
  c = new classify.Classifier classify.splitters.simple

  c.train "The only way to deal with an unfree world is to become so absolutely free that your very existence is an act of rebellion.", "camus"

  c.train "Nothing is more despicable than respect based on fear.", "camus"

  c.train "Man is condemned to be free; because once thrown into the world, he is responsible for everything he does.", "sartre"

  t.deepEqual c.categories().sort(), ["camus", "sartre"], "categories"
  t.equal c.doc_count(), 3, "documents"

  t.deepEqual c.category_count("camus"), 2, "category count"

  t.deepEqual c.feature_count("is", "camus"), 2, "feature count in category"

  t.end()

