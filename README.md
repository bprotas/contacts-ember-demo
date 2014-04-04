# Contact manager example

This is a very simple contact manager app consisting of a Sinatra backend
and a frontend written in EmberJS.  The Ruby/Sinatra app is in the
_server_ directory, the EmberJS app is in the _app_ directory, and the
other directories and files at the root contain support code for the Ember app from Ember App
Kit.

## Getting Started

### Configuring the Sinatra backend

You will need Ruby 2.0 or later, and bundler installed.  

In the _server_ directory, install the required Ruby modules by running 

    bundle install 

You can now run the Sinatra server under your favorite Rack server, or
use the _rackup_ command line to run it standalone.

### Configuring the EmberJS frontend

The EmberJS app uses Ember App Kit to manage its development and build
environment, so you'll need to install EAK's dependencies:

  - Install nodeJS for your environment
  - Install grunt-cli with:
      
         npm install -g grunt-cli

  - Install bower with:
        
         npm install -g bower

  - From the project's root directory, install the project's
dependencies with:

         npm install


Next, you'll need to configure where the EmberJS app can talk to the
Sinatra API; you can do this in _app/app.js_, though the default of
http://localhost:9292 will work if you used _rackup_ above to run
server.


Finally, execute _grunt server_ from the root directory of the project,
to serve the application in development mode.   Navigate to
http://localhost:8000 using Chrome, Safari, or Firefox, and you're good
to go!

### Running Tests

The server component includes _rspec_ unit tests; change to the _server_
directory and execute _rspec_ to run them.

The EmberJS app includes an in-browser integration test that exercises
the server component and application frontend code; navigate to
http://localhost:8000/tests to run them.



