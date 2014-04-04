require "active_support/all"

RSpec::Matchers.define :be_emberdata_compatible_for do |model|
  match do |actual|
    [model.singularize, model.pluralize].include?(actual.keys.first).should == true

    data = actual[actual.keys.first]

    if data.is_a?(Hash)
      data.values.select{|el| el.is_a? Hash}.count.should == 0
    else
      data.each{|row| row.select{|el| el.is_a? Hash}.count.should == 0}
    end
  end
end
