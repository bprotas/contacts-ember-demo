export default Ember.View.extend({
  templateName: 'fieldset',
  disableInputs: Em.computed.alias("parentView.disableInputs"),
  editable: Em.computed.alias("parentView.editable"),
});
