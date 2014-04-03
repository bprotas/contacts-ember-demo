export default Ember.ObjectController.extend(Ember.Evented).extend({
  editable: false,
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
    if (this.isNewModel()) {
      return(
        this.store.createRecord('contact', this.get('content')).save()
      );
    }
    else {
      return(this.get('content').save())
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
