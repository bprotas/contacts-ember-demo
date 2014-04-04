ENV['RACK_ENV'] = "test"
ENV['contact_list_file'] = "spec/data/contacts.json"

require_relative "../contact_server_app.rb"
require "rack/test"
require "json"
require "open-uri"
require_relative "matchers/emberdata"

describe ContactServerApp do
  include Rack::Test::Methods

  def app
    ContactServerApp
  end

  def parsed_response
    JSON.parse(last_response.body)
  end

  def contact_for(name, email)
    @contacts_list.find{|contact|
      contact["name"] == name && contact["email"] == email
    }
  end

  def url_for(name, email)
    "/contacts/#{contact_for(name, email)["id"]}"
  end

  before(:each) do
    get '/contacts'
    @contacts_list = parsed_response["contacts"]
  end

  it "lists contacts" do
    parsed_response.should be_emberdata_compatible_for "contacts"
    @contacts_list.count.should == 3
  end

  it "can lookup a contact" do
    get url_for("Doug Stamper", "thestamper@hotmail.com")
    parsed_response.should be_emberdata_compatible_for "contacts"
    parsed_response["contact"]["name"].should == "Doug Stamper"
    parsed_response["contact"]["email"].should == "thestamper@hotmail.com"
  end

  it "can update an existing contact" do
    put url_for("Doug Stamper", "thestamper@hotmail.com"),
      {contacts:  {email: "dougstamper@gmail.com"}}.to_json,
      "Content-Type" => "application/json"

    parsed_response.should be_emberdata_compatible_for "contacts"

    get url_for("Doug Stamper", "thestamper@hotmail.com")
    parsed_response.should be_emberdata_compatible_for "contacts"
    parsed_response["contact"]["name"].should == "Doug Stamper"
    parsed_response["contact"]["email"].should == "dougstamper@gmail.com"
  end

  it "can create a new contact" do
    post "/contacts",
      {contacts: {name: "new test contact", email: "newtestcontactemail@gmail.com", sex: "testing"}}.to_json,
      "Content-Type" => "application/json"

    parsed_response.should be_emberdata_compatible_for "contacts"

    get '/contacts'
    parsed_response.should be_emberdata_compatible_for "contacts"
    new_list = JSON.parse(last_response.body)["contacts"]

    new_list.count.should == @contacts_list.count + 1

    new_list.select{|contact|
      contact["name"] == "new test contact" &&
        contact["email"] == "newtestcontactemail@gmail.com" &&
        contact["sex"] == "testing"
    }.count.should == 1


  end

end
