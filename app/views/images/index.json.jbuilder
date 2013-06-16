json.array!(@images) do |image|
  json.extract! image, :id, :fname, :author, :parent, :public
  json.url image_url(image, format: :json)
end