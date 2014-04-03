var Router = Ember.Router.extend();

Router.map(function() {
  this.resource('contacts', {path: '/'}, function() {
    this.route('new');
    this.resource('contact', {path: '/contact/:contact_id'});
  });


  // For testing:
  this.route('component-test');
  this.route('helper-test');
});

export default Router;
