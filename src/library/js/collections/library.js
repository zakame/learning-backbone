var Book = require('../models/book');

var Library = Backbone.Collection.extend({
  model: Book,
  url: '/api/books'
});

module.exports = Library;
