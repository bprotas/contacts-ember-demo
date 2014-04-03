RSpec::Matchers.define :be_emberdata_compatible_for do |model|
  match do |actual|
    actual.keys.include?(model).should == true
  end
end
