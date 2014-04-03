export default Ember.View.extend({
  tagName: 'a',
  attributeBindings: ['href'],
  classNames: ['list-group-item'],
  classNameBindings: ['active'],
  templateName: 'contact_summary',

  href: function() {
    if (this.get('content').get('id') !== null) {
      return("/#/contact/" + this.get('content').get('id'));
    }
    else {
      return('/#/new');
    }
  }.property('content.id'),

  active: function() {
    return(this.get('content').get('id') == this.get('controller').get('selectedContactId'));
  }.property('controller.selectedContactId')

});
