fs = require 'fs'

stop_words = ['a','able','about','across','after','all','almost','also','am','among','an','and','any','are','as','at','be','because','been','but','by','can','cannot','could','dear','did','do','does','either','else','ever','every','for','from','get','got','had','has','have','he','her','hers','him','his','how','however','i','if','in','into','is','it','its','just','least','let','like','likely','may','me','might','most','must','my','neither','no','nor','not','of','off','often','on','only','or','other','our','own','rather','said','say','says','she','should','since','so','some','than','that','the','their','them','then','there','these','they','this','tis','to','too','twas','us','wants','was','we','were','what','when','where','which','while','who','whom','why','will','with','would','yet','you','your']

sum = (lst) ->
  s = 0
  s += v for v in lst
  s

normf = (obj) ->
  s = sum (v for k,v of obj)
  r = []
  for k, v of obj
    r.push [k, parseInt(v / s * 1000) / 1000] if v isnt 0
  r.sort (a, b) -> b[1] - a[1]
  r

splitters =
  simple: (doc, remove_stop_words=false) ->
    t = {}
    tokens = doc.split /\W+/g
    t[token.toLowerCase()] = true for token in tokens
    tokens = (k for k, v of t)
    if remove_stop_words
      tokens = (t for t in tokens when stop_words.indexOf(t) is -1)
    tokens

class Classifier
  
  constructor: (@splitter, @remove_stop_words=false) ->
    @fc = {}
    @cc = {}
    
  incf: (feature, category) ->
    if not @fc?[feature]
      @fc[feature] = {}
    if not @fc[feature][category]
      @fc[feature][category] = 0
    @fc[feature][category] += 1

  incc: (category) ->
    if not @cc[category]
      @cc[category] = 0
    @cc[category] += 1

  feature_count: (feature, category) -> @fc?[feature]?[category] or 0

  category_count: (category) -> @cc?[category] or 0

  doc_count: -> sum (v for k, v of @cc)

  categories: -> (k for k, v of @cc)

  train: (doc, category) ->
    @incf(feature, category) for feature in @splitter(doc, @remove_stop_words)
    @incc(category)

  prob_feature_in_category: (feature, category) ->
    if not @cc?[category]
      0
    else
      @feature_count(feature, category) / @category_count(category)

  weighted_probability: (feature, category, prob_func, weight=1.0, ap=0.5) ->
    basic = prob_func feature, category
    totals = sum (@feature_count(feature, c) for c in @categories())
    ((weight * ap) + (totals*basic)) / (weight + totals)

  persist: (filename) ->
    fs.writeFileSync filename, JSON.stringify
      fc: @fc
      cc: @cc

  load: (filename) ->
    obj = JSON.parse fs.readFileSync filename, 'utf-8'
    @fc = obj.fc
    @cc = obj.cc    

class Fisher
  constructor: (@classifier) ->
    
  feature_in_category: (feature, category) ->
    feature_category_probability = @classifier.prob_feature_in_category(feature, category)
    return 0 if feature_category_probability is 0

    freq_sum = sum (@classifier.prob_feature_in_category(feature, category) for category in @classifier.categories())
    
    feature_category_probability / freq_sum

  probability: (document, category) ->
    features = @classifier.splitter(document, @classifier.remove_stop_words)
    p = 1
    for feature in features
      console.log feature
      p *= @classifier.weighted_probability(feature, category, @feature_in_category)
      console.log p

    fscore = Math.log(p) * -2

    @invchi2 fscore, features.length * 2
    
  invchi2: (fscore, l) ->
    m = fscore / 2.0
    s = t = Math.exp(m * -1)
    for i in [0..Math.floor(l/2)]
      t *= m / i
      s += t
    if m < 0 then m else 1

  classifications: (document) ->
    cats = {}
    for category in @classifier.categories()
      cats[category] = @probability document, category
    cats

    top = 0
    top_category = null
    for k, v of cats
      if v > top
        top_category = k
        top = v

    [top_category, normf(cats)]

class NaiveBayes
  constructor: (@classifier) ->

  document_probability: (document, category) ->
    features = @classifier.splitter(document, @classifier.remove_stop_words)
    p = 1
    for feature in features
      p *= @classifier.weighted_probability(feature, category, @classifier.prob_feature_in_category, 1, 0.01)
    p

  probability: (document, category) ->
    category_probability = @classifier.category_count(category) / @classifier.doc_count()
    console.log @classifier.category_count(category), @classifier.doc_count()
    document_probability = @document_probability(document, category)
    console.log document, category, category_probability, document_probability, category_probability * document_probability
    console.log "---"
    category_probability * document_probability

  classifications: (document) ->
    cats = {}
    for category in @classifier.categories()
      cats[category] = @probability document, category
    cats

    top = 0
    top_category = null
    for k, v of cats
      if v > top
        top_category = k
        top = v

    [top_category, normf(cats)]

exports.Classifier = Classifier
exports.NaiveBayes = NaiveBayes
exports.Fisher     = Fisher
exports.splitters = splitters
