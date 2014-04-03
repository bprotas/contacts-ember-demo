export default Ember.View.extend({
  tagName: 'a',
  attributeBindings: ['href'],
  classNames: ['list-group-item'],
  classNameBindings: ['active', 'disabled'],
  templateName: 'contact_summary',
  disabled: Ember.computed.alias("controller.editable"),

  href: function() {
    if (this.get('content').get('id') !== null) {
      return("/#/contact/" + this.get('content').get('id'));
    }
    else {
      return('/#/new');
    }
  }.property('content.id'),

  click: function() {
    if (this.get('disabled')) {
      event.preventDefault();
    }
  },

  active: function() {
    return(this.get('content').get('id') == this.get('controller').get('selectedContactId'));
  }.property('controller.selectedContactId')
});
