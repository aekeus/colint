# colint

Collective intelligence library

# purpose

colint defines a set of classes and functions useful for collective intelligence /
artificial intelligence tasks. (classification, regression, estimation etc...)

This repository was inspired by the book Collective Intelligence by Toby Segaran 2007.

# example

```
colint = require 'colint'

# create a NaiveBayes classifier with a simple token splitter
nb = new colint.classify.NaiveBayes(coilint.classify.simple)

nb.train "This is the text of some document", "category"

[top_category, stats] = nb.classifications "Document to classify"
```

# install

With [npm](https://npmjs.org) do:

```
sudo npm install colint
```

# license

MIT