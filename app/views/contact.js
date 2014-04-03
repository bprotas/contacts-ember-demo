export default Ember.View.extend({
  disableInputs: false,
  editable: false,
  save_message: "",
  panel_type: "panel-primary",
  controller_events: ['saveSuccess', 'saveFail', 'startEdit', 'endEdit', 'startSave'],

  didInsertElement: function() {
    var controller = this.get('controller');
    for (var i=0; i<this.controller_events.length; i++) {
      controller.on(this.controller_events[i], this,
                    this[this.controller_events[i]]
                   );
    }

    this.set('editable', controller.get('editable'));
  },
  willClearRender: function() {
    var controller = this.get('controller');
    for (var i=0; i < this.controller_events.length; i++) {
      controller.off(this.controller_events[i]);
    }
  },

  saveSuccess: function() {
    this.set('panel_type', 'panel-success');
    this.set('save_message', 'Saved!');

    setTimeout(jQuery.proxy(this.returnToNormal, this), 3000);
  },

  returnToNormal: function() {
    if (!this.isDestroyed) {
      this.set('panel_type', 'panel-primary');
      this.set('save_message', '');
    }
  },

  saveFail: function() {
    this.set('panel_type', 'panel-danger');
    this.set('save_message', 'Save Failed :(');
  },

  startEdit: function() {
    this.set('editable', true);
  },

  endEdit: function() {
    this.set('editable', false);
    this.set('disableInputs', false);
  },

  startSave: function() {
    this.set('disableInputs', true);
  }
});
