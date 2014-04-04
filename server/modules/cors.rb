require "sinatra/base"

module Sinatra
  module CORS
    def self.registered(app)
      app.before do
        # Enable CORS so that this app can respond directly to API calls from the Ember app:
        content_type :json
        headers 'Access-Control-Allow-Origin' => '*',
                'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST', 'PUT'],
                'Access-Control-Allow-Headers' => ['Content-Type', "testmode"]

      end

      app.options "*" do
        ""
      end
    end
  end
end
