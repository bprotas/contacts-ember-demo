class EmberDataAdapter
  def initialize(model_name)
    @model_name = model_name.gsub(/s$/, "")
    @to_flatten = {}
  end

  def flatten(key, subkeys)
    @to_flatten[key] = Array(subkeys)
  end

  def output(data)
    model_name = plural?(data) ? "#{@model_name}s" : @model_name

    {
      model_name.to_s => flattened(data)
    }.to_json
  end

  def input(json)
    full = JSON.parse(json)
    unflattened(
      full.has_key?(@model_name) ? full[@model_name] : full["#{@model_name}s"]
    )
  end

  private
  def flattened(data)
    flattened_data = clone data

    @to_flatten.keys.each{|flatten_key|
      flattened_data= Array(flattened_data).map{|row| apply_flatten flatten_key, row}
    }

    plural?(data) ? flattened_data : flattened_data[0]
  end

  def unflattened(data)
    unflattened_data = clone data
    @to_flatten.each{|subkey, flattened_keys|
      unflattened_data = Array(unflattened_data).map{|row| unflatten flattened_keys, subkey, row}
    }

    plural?(data) ? unflattened_data : unflattened_data[0]
  end

  def apply_flatten(subkey, data)
    subdata = data[subkey]
    data.delete subkey
    data.merge!(subdata || {})
  end

  def unflatten(flattened_keys, subkey, data)
    key_detector = proc {|key, val| flattened_keys.include? key}
    subdata = data.select(&key_detector)
    remaining_data = data.reject(&key_detector)

    remaining_data[subkey] = subdata if subdata.count > 0

    remaining_data
  end

  def plural?(data)
    data.is_a? Array
  end

  def clone(data)
    cloned = JSON.parse data.to_json
    cloned = [cloned] if data.is_a? Hash

    cloned
  end
end
