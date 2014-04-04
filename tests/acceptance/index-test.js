var App;

module('Acceptances - Index', {
  setup: function(){
    $.ajax({
      type: "POST",
      url: window.EMBER_API_HOST + "/test/start",
      async: false
    });

    App = startApp();
    App.reset();
  },
  teardown: function() {
    Ember.run(App, 'destroy');
  }
});

test('contact list lists contacts', function() {
  visit('/').then(function() {
    var list = find('.contact-list .list-group a');
    equal(list.length, 3);
    equal(list.first().text().trim(), "Doug Stamper");
    equal(list.last().text().trim(), "Zoey Barnes");
  });
});

test('contact details can be shown', function() {
  visit('/contact/2c6oe0rkg06r4').then(function() {
    equal(
      find(".contact-detail .panel-title").text().trim(),
      "Doug Stamper"
    );
  });
});

test('contacts can be edited', function() {
  visit('/contact/2c6oe0rkg06r4').then(function() {
    click('.contact-detail .panel-title a').then(function() {
      equal(find('.contact-detail .panel-heading input').length, 1);

      fillIn("input[name='name']", "Test Update");
      click("button:contains('Save')").then(function() {
        equal(find('.contact-detail .panel-heading .description').text(), 'Saved!');
      });
    });
  });


  andThen(function() {
    visit('/');
    equal(find('.contact-list .list-group a').first().text().trim(), "Test Update");
  });
});

test('new contacts can be created', function() {
  visit('/new').then(function() {
    fillIn("input[name='name']", "Added Contact");
    fillIn("input[name='email']", "thenewguy@gmail.com");
    click("button:contains('Save')");
  });

  andThen(function() {
    visit('/');
    equal(find('.contact-list .list-group a').length, 4);
    equal(find('.contact-list .list-group a').last().text().trim(), "Added Contact");
  });

  andThen(function() {
    var newguy_id = find('.contact-list .list-group a').last().attr('href').split('/').pop();
    visit('/contact/' + newguy_id);
    ok(find('.contact-detail').text().indexOf("thenewguy@gmail.com") != -1, "email is shown in the contact details");
  });
})

