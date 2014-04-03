export default DS.RESTAdapter.extend({
  host: window.EMBER_API_HOST,
  headers: headersForEnvironment()
});

function headersForEnvironment() {
  if (window.App.rootElement == "#ember-testing") {
    // Integration tests - ask our app to serve up the fixtures:
    return({"TESTMODE": "1"});
  }
  else {
    return({});
  }
}
