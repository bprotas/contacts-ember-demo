export default Ember.ObjectController.extend(Ember.Evented).extend({
  editable: false,
  save_message: "",
  actions: {
    save: function() {
      this.trigger('startSave');

      var controller = this;

      this.persist().then(function() {
        controller.trigger('saveSuccess');
        controller.trigger('endEdit');
      }).catch(function(reason) {
        controller.trigger('saveFail');
        controller.trigger('endEdit');
      });
    },

    cancel: function() {
      this.stopEdit();
    },

    edit: function() {
      this.startEdit();
    }
  },

  isNewModel: function() {
    return(this.get('content').id === undefined);
  },

  persist: function() {
    var model_instance;

    if (this.isNewModel()) {
      model_instance = this.store.createRecord('contact', this.get('content'));
    }
    else {
      model_instance = this.get('content');
    }

    var validation_error = model_instance.validate();

    if (validation_error) {
      return(Promise.reject(validation_error));
    }
    else {
      return(model_instance.save());
    }
  },

  startEdit: function() {
    this.set('editable', true);
    this.trigger('startEdit');
  },

  stopEdit: function() {
    this.set('editable', false);
    this.trigger('endEdit');
  }
})
