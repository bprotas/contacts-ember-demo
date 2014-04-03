export default Ember.ArrayController.extend({
  selectedContactController: null,
  editable: Em.computed.alias("selectedContactController.editable"),

  selectedContactId: function() {
    if (this.get('selectedContactController') && this.get('selectedContactController').get('content')) {
      return(this.get('selectedContactController').get('content').get('id'));
    }
    else {
      return null;
    }
  }.property('selectedContactController', 'selectedContactController.content'),

  cleanupAbandonedNewContacts: function() {
    // Instead of just destroying here, we could also give the user a chance
    // to confirm:
    this.store.all('contact').content.forEach(function(contact) {
      if (contact.get('id') === null) {
        contact.deleteRecord();
      }
    });
  }
});
