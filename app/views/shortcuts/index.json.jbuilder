json.array!(@shortcuts) do |shortcut|
  json.extract! shortcut, :id, :url, :target
  json.url shortcut_url(shortcut, format: :json)
end
