var BookView = Backbone.View.extend({
  tagName: 'div',
  className: 'bookContainer',
  events: {
    'click .delete': 'deleteBook'
  },
  template: _.template( $('#bookTemplate').html() ),
  deleteBook: function() {
    this.model.destroy();

    this.remove();
  },
  render: function() {
    this.$el.html( this.template( this.model.attributes ) );
    return this;
  }
});

module.exports = BookView;
