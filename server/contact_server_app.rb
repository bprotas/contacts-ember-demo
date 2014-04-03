require "bundler"
require "active_support/all"
require "json"
Bundler.require

require_relative "models/contact_list.rb"

class ContactServerApp < Sinatra::Base

  before do
    # Enable CORS so that this app can respond directly to API calls from the Ember app:
    content_type :json
    headers 'Access-Control-Allow-Origin' => '*',
      'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST', 'PUT'],
      'Access-Control-Allow-Headers' => ['Content-Type', "testmode"]
  end

  options "*" do
    ""
  end

  def initialize
    super
    @contacts = load_contacts(ENV['contact_list_file'])
  end

  get "/contacts" do
    {"contacts" => contacts.contacts}.to_json
  end

  post "/contacts" do
    data = parsed_body["contact"]
    begin
      added = contacts.add data["name"].to_s, data["email"].to_s, data
      {"contacts" => added}.to_json
    rescue ContactListException::Duplicate
      halt 409, "Contact name and email already exists"
    end
  end

  get "/contacts/:id" do |id|
    begin
      {"contacts" => contacts.lookup(id)}.to_json
    rescue ContactListException::Notfound
      halt 404, "contact not found"
    end
  end

  put "/contacts/:id" do |id|
    begin
      contacts.update id, parsed_body["contact"]
    rescue ContactListException::NotFound
      halt 404, "contact not found"
    end

    {"contacts" => contacts.lookup(id)}.to_json
  end

  post "/test/start" do
    # Puts the server into integration test mode; flushes any pending changes
    # and reloads from the fixtures:
    reset_test_contacts
  end

  private
  def contacts
    if test_mode?
      STDERR.puts "in test mode"
      reset_test_contacts if @test_contacts.nil?
      @test_contacts ||= reset_test_contacts
      @test_contacts
    else
      @contacts
    end
  end

  def reset_test_contacts
    STDERR.puts "resetting test contacts"
    @test_contacts = load_contacts "spec/data/contacts.json"
  end

  def test_mode?
    request.env['HTTP_TESTMODE'].to_i == 1
  end

  def parsed_body
    request.body.rewind
    JSON.parse request.body.read
  end

  def load_contacts(list_file)
    ContactList.new(list_file)
  end
end
