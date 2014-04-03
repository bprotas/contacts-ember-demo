import Resolver from 'ember/resolver';

window.EMBER_API_HOST = "http://localhost:9292"

var App = Ember.Application.extend({
  LOG_ACTIVE_GENERATION: true,
  LOG_MODULE_RESOLVER: true,
  LOG_TRANSITIONS: true,
  LOG_TRANSITIONS_INTERNAL: true,
  LOG_VIEW_LOOKUPS: true,
  modulePrefix: 'appkit',
  Resolver: Resolver['default']
});




export default App;
