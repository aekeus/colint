# colint

Collective intelligence library

# purpose

colint defines a set of classes and functions useful for collective intelligence /
artificial intelligence tasks. (classification, regression, estimation etc...)

This repository was inspired by the book Collective Intelligence by Toby Segaran 2007.

# example

```
colint = require 'colint'

classify = colint.classify

# create a NaiveBayes classifier with a simple token splitter
nb = new classify.NaiveBayes(classify.splitters.simple)

nb.train "This is the text of some document", "category"

[top_category, stats] = nb.classifications "Document to classify"
```

see /examples folder for a working classification, recommendation and decision tree example

# install

With [npm](https://npmjs.org) do:

```
npm install colint
```

# license

MIT