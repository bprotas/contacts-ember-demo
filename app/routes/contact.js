export default Ember.Route.extend({
  setupController: function(controller, model) {
    this._super(controller, model);
    controller.stopEdit();
    this.controllerFor('contacts').set('selectedContactId', model.get('id'));
  }
})
