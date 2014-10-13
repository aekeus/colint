# Refer to chapter 6, Collective Intelligence, Toby Segaran 2007

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
    r.push [k, parseInt(v / s * 1000) / 1000] if v > 0.0001
  r.sort (a, b) -> b[1] - a[1]
  r

splitters =
  simple: (doc, opts={}) ->
    throw "opts must be an 'object' not '#{typeof opts}'" unless typeof opts is 'object'
    opts.remove_stop_words or= false
    t = {}
    tokens = doc.split /\W+/g
    t[token.toLowerCase()] = true for token in tokens
    tokens = (k for k, v of t)
    if opts.remove_stop_words
      tokens = (t for t in tokens when stop_words.indexOf(t) is -1)
    tokens

class Classifier

  # constructor(Function, Boolean) -> Void
  #
  # Build a classifier object
  constructor: (@splitter, @splitter_opts={}) ->
    @fc = {}
    @cc = {}

  # incf() -> Void
  #
  # Increment the number of times a feature apeared in a document
  # in a category
  incf: (feature, category) ->
    if not @fc?[feature]
      @fc[feature] = {}
    if not @fc[feature][category]
      @fc[feature][category] = 0
    @fc[feature][category] += 1

  # incc() -> Void
  #
  # Increment the document count in a category
  incc: (category) ->
    if not @cc[category]
      @cc[category] = 0
    @cc[category] += 1

  # feature_count(String, String) -> Integer
  # 
  # Number of times a document contained a feature in a category
  feature_count: (feature, category) -> @fc?[feature]?[category] or 0

  # category_count(String) -> Integer
  #
  # Number of document in a category
  category_count: (category) -> @cc?[category] or 0

  # doc_count() -> Integer
  #
  # Number of documents in all categories
  doc_count: -> sum (v for k, v of @cc)

  # categories() -> Array[String]
  #
  # Array of categories seen so far
  categories: -> (k for k, v of @cc)

  train: (doc, category) ->
    @incf(feature, category) for feature in @splitter(doc, @splitter_opts)
    @incc(category)

  prob_feature_in_category: (feature, category) ->
    if not @cc?[category]
      0
    else
      @feature_count(feature, category) / @category_count(category)

  weighted_probability: (feature, category, weight=1.0, ap=0.5) ->
    basic = @prob_feature_in_category feature, category
    totals = sum (@feature_count(feature, c) for c in @categories())
    ((weight * ap) + (totals*basic)) / (weight + totals)

  # classifications(String) -> Array[String, Array[Array[String, Float]]]
  #
  # Calculate the top category for a document and the probabilities
  # for each of the categories trained so far.
  #
  # [ 'top_category',
  #   [ [ 'top_category', 0.95 ]
  #     [ 'next_category', 0.002 ] ] ]
  # 
  classifications: (document) ->
    cats = {}
    cats[category] = @probability(document, category) for category in @categories()

    top = 0
    top_category = null
    for k, v of cats
      if v > top
        top_category = k
        top = v

    [top_category, normf(cats)]

class Fisher extends Classifier

  basic_feature_in_category: (feature, category) ->
    if not @cc?[category]
      0
    else
      @feature_count(feature, category) / @category_count(category)

  prob_feature_in_category: (feature, category) ->
    feature_category_probability = @basic_feature_in_category feature, category
    return 0 if feature_category_probability is 0

    freq_sum = sum (@basic_feature_in_category(feature, category) for category in @categories())

    feature_category_probability / freq_sum

  # probability(String, String) -> Float
  #
  # Calculates the probability that a document is in a category (Fisher)
  # 
  probability: (document, category) ->
    features = @splitter document, @splitter_opts
    p = 1
    for feature in features
      p *= @weighted_probability feature, category
    fscore = Math.log(p) * -2
    @invchi2 fscore, features.length * 2
    
  invchi2: (fscore, l) ->
    m = fscore / 2.0
    s = t = Math.exp(m * -1)
    for i in [1..Math.floor(l / 2)]
      t *= m / i
      s += t
    if s > 1 then 1 else s

class NaiveBayes extends Classifier

  document_probability: (document, category) ->
    features = @splitter document, @splitter_opts
    p = 1
    for feature in features
      p *= @weighted_probability feature, category, 1, 0.01
    p

  # probability(String, String) -> Float
  #
  # Calculates the probability that a document is in a category (Bayes)
  # 
  probability: (document, category) ->
    category_probability = @category_count(category) / @doc_count()
    document_probability = @document_probability document, category
    category_probability * document_probability

class FilePersist
  constructor: (@classifier) ->
    
  persist: (filename) ->
    fs.writeFileSync filename, JSON.stringify
      fc: @classifier.fc
      cc: @classifier.cc

  load: (filename) ->
    obj = JSON.parse fs.readFileSync filename, 'utf-8'
    @classifier.fc = obj.fc
    @classifier.cc = obj.cc    

exports.Classifier = Classifier
exports.NaiveBayes = NaiveBayes
exports.Fisher     = Fisher

exports.FilePersist = FilePersist

exports.splitters = splitters
