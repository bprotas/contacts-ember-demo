require "json"
require "active_support/all"

class ContactList
  def initialize(filename=nil)
    filename = "data/contacts.json" if filename.nil?
    @contacts = Array(JSON.parse File.new(filename).read).inject({}){|memo, contact|
      contact["id"] = id_for contact
      memo[contact["id"]] = default_pic contact
      memo
    }
  end

  def contacts
    @contacts.values
  end

  def lookup(id)
    raise ContactListException::NotFound unless @contacts[id.to_s]
    @contacts[id.to_s]
  end

  def find(name, email=nil)
    contacts_for("name", name) & contacts_for("email", email)
  end

  def add(name, email, data)
    data["name"] = name
    data["email"] = email
    data["id"] = id_for data

    raise ContactListException::Duplicate.new if @contacts[data["id"]]

    @contacts[data["id"]] = data

    data
  end

  def update(id, data)
    raise ContactListException::NotFound.new unless @contacts[id]

    data.each{|key, value|
      @contacts[id][key.to_s] = value
    }

    @contacts[id]
  end

  private
  def contacts_for(field, value)
    return @contacts.values if value.to_s.blank?
    Array(@contacts.values.select{|c| c[field.to_s] == value})
  end

  def id_for(contact)
    SipHash.digest("thisissomereallylongseed", "#{contact['name']}::#{contact['email']}".to_s).to_s(36)
  end

  def default_pic(contact)
    contact["pic"] = "/assets/default_headshot.png" if contact["pic"].to_s.blank?
    contact
  end

end

module ContactListException
  class NotFound < Exception
  end

  class Duplicate < Exception
  end
end
