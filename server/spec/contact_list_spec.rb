require_relative "../models/contact_list.rb"

describe ContactList do
  before(:each) do
    @contact_list = ContactList.new("spec/data/contacts.json")
  end

  it "loads data on initialization" do
    @contact_list.contacts.count.should == 3
  end

  it "sets a unique, non-blank ID for each contact" do
    ids = @contact_list.contacts.map{|c| c["id"]}.reject{|id| id.to_s.blank?}
    ids.uniq.length.should == @contact_list.contacts.length
  end

  it "can find contacts by id" do
    some_id = @contact_list.contacts.map{|c| c["id"]}.sample

    contact = @contact_list.lookup some_id
    contact["id"].should == some_id
  end

  it "can find contacts by name" do
    @contact_list.find("Zoey Barnes").count.should == 1
  end

  it "can find contacts by name and email" do
    @contact_list.find("Zoey Barnes", "zbarnes@slugline.com").count.should == 1
  end

  it "doesn't find anyone if the name and email don't match" do
    @contact_list.find("Zoey Barnes", "thestamper@hotmail.com").count.should == 0
    @contact_list.find("Doug Stamper", "zbarnes@slugline.com").count.should == 0
  end

  it "can add contacts to the list" do
    @contact_list.find("Ben Protas").count.should == 0
    added = @contact_list.add("Ben Protas", "ben@benprotas.com", {})
    @contact_list.find("Ben Protas").count.should == 1

    added["id"].should_not be_blank
  end

  it "raises an exception on add of an existing contact name/email" do
    expect{@contact_list.add("Doug Stamper", "thestamper@hotmail.com", {})}.to raise_error(ContactListException::Duplicate)
  end

  it "can update contacts in the list" do
    @contact_list.update(
      @contact_list.find("Doug Stamper")[0]["id"],
      { "email" => "ben@benprotas.com" }
    )

    @contact_list.find("Doug Stamper")[0]["email"].should == "ben@benprotas.com"
  end

  it "raises an exception on update of a non-existent contact" do
    expect{@contact_list.update(123, {})}.to raise_error(ContactListException::NotFound)
  end
end
