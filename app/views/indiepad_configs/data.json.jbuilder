settings = Settings.indiepad
result = {}

@indiepad_config.data.each_with_index do |player, i|
  result[i] = []
  settings.default.each do |default_key, _|
    key = player[default_key.to_s]
    result[i] << [settings.keycodes[key], settings.keynames[key]]
  end
end

json.keys result
