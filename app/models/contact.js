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
  pic: attr()
});

