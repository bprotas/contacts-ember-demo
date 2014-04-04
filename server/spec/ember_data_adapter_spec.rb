require_relative "../lib/ember_data_adapter.rb"
require_relative "matchers/hash_keys.rb"

def has_keys(hash, keys)
  Array(keys).each{|k| hash.should have_key k}
end

def lacks_keys(hash, keys)
  Array(keys).each{|k| hash.should_not have_key k}
end

describe EmberDataAdapter do
  before(:each) do
    @adapter = EmberDataAdapter.new "tests"
    @adapter.flatten "nested", ["nested_1", "nested_2", "nested_3"]
  end

  it "puts its output under the right model key" do
    output = JSON.parse(@adapter.output({a: "hi"}))
    output.keys.first.should == "test"

    output = JSON.parse(@adapter.output([{a: "1"}, {a: "2"}]))
    output.keys.first.should == "tests"
  end

  it "flattens nested output" do
    example = {a: "hi", nested: {nested_1: "b", nested_2: "c", nested_3: "d"}}
    output = JSON.parse(@adapter.output(example))["test"]

    output.should lack_keys "nested"
    output.should have_keys "nested_1", "nested_2", "nested_3"

    many_examples = JSON.parse(@adapter.output((1..5).to_a.map{ example }))["tests"]
    many_examples.each{|ex|
      ex.should lack_keys "nested"
      ex.should have_keys "nested_1", "nested_2", "nested_3"
    }

  end

  it "nests flattened input" do 
    example = {a: "hi", nested_1: "b", nested_2: "c", nested_3: "d"}
    input = @adapter.input({test: example}.to_json)

    input.should have_keys "nested"
    input.should lack_keys "nested_1", "nested_2", "nested_3"
    input["nested"].should have_keys "nested_1", "nested_2", "nested_3"
    input["nested"]["nested_2"].should == "c"

    many_examples = (1..5).map{ example }
    input = @adapter.input({tests: many_examples}.to_json)

    input.each{|ex|
      ex.should have_keys "nested"
      ex.should lack_keys "nested_1", "nested_2", "nested_3"
      ex["nested"].should have_keys "nested_1", "nested_2", "nested_3"
      ex["nested"]["nested_1"].should == "b"
    }
  end


  
end

