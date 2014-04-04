RSpec::Matchers.define :have_keys do |*keys|
  match do |hash|
    Array(keys).each{|k| hash.should have_key k}
  end
end

RSpec::Matchers.define :lack_keys do |*keys|
  match do |hash|
    Array(keys).each{|k| hash.should_not have_key k}
  end
end
