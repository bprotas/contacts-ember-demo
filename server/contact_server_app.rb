require "bundler"
require "active_support/all"
require "json"
Bundler.require

require_relative "models/contact_list.rb"
require_relative "modules/cors.rb"
require_relative "lib/ember_data_adapter.rb"

class ContactServerApp < Sinatra::Base
  register Sinatra::CORS

  def initialize
    super
    @contacts = load_contacts(ENV['contact_list_file'])
    @ember_data_adapter = EmberDataAdapter.new("contacts")
    @ember_data_adapter.flatten "address", %w(street city state postcode)
  end

  get "/contacts" do
    adapter.output contacts.contacts
  end

  post "/contacts" do
    data = adapter.input request.body.read
    begin
      added = contacts.add data["name"].to_s, data["email"].to_s, data
      adapter.output added
    rescue ContactListException::Duplicate
      halt 409, "Contact name and email already exists"
    end
  end

  get "/contacts/:id" do |id|
    begin
      adapter.output contacts.lookup(id)
    rescue ContactListException::NotFound
      halt 404, "contact not found"
    end
  end

  put "/contacts/:id" do |id|
    begin
      contacts.update id, adapter.input(request.body.read)
    rescue ContactListException::NotFound
      halt 404, "contact not found"
    end

    adapter.output contacts.lookup(id)
  end

  post "/test/start" do
    # Puts the server into integration test mode; flushes any pending changes
    # and reloads from the fixtures:
    reset_test_contacts
  end

  get "/raw" do
    contacts.contacts.to_json
  end

  private
  def contacts
    if test_mode?
      reset_test_contacts if @test_contacts.nil?
      @test_contacts ||= reset_test_contacts
      @test_contacts
    else
      @contacts
    end
  end

  def reset_test_contacts
    @test_contacts = load_contacts "spec/data/contacts.json"
  end

  def test_mode?
    request.env['HTTP_TESTMODE'].to_i == 1
  end

  def load_contacts(list_file)
    ContactList.new(list_file)
  end

  def adapter
    @ember_data_adapter
  end
end
