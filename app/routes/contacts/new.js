export default Ember.Route.extend({
  controllerName: "contact",
  model: function() {
    return(this.store.createRecord('contact', {name: "New Contact"}));
  },
  renderTemplate: function() {
    this.render('contact');
  },
  setupController: function(controller, model) {
    this._super(controller, model);
    this.controllerFor('contacts').set('selectedContactController', controller);
    controller.startEdit();
  },
  actions: {
    willTransition: function(transition) {
      // When leaving the new contact route, we need to make sure
      // that our changes have either been saved or are thrown away:
      App.__container__.lookup("controller:contacts").cleanupAbandonedNewContacts()
      return(true);
    }
  }
});
