export default Ember.ArrayController.extend({
  selectedContactId: null,

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
