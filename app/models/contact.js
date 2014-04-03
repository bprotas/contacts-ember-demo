var attr = DS.attr;

export default DS.Model.extend({
  name: attr(),
  email: attr(),
  sex: attr(),
  age: attr(),
  birthday: attr(),
  phone: attr(),
  street: attr(),
  city: attr(),
  state: attr(),
  postcode: attr(),
  pic: attr(),

  validate: function() {
    if (this.get('name') == '') {
      return("Must specify name");
    }

    if (this.get('name') == 'New Contact') {
      return("Sorry, can't use 'New Contact' as a contact name");
    }
    
    return(null);
  }
});

