json.array!(@foods) do |food|
  json.extract! food, :dish, :year, :qty
  json.url food_url(food, format: :json)
end
