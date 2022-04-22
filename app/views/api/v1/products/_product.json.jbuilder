json.id product.id
json.name product.name
json.description product.description
json.array!(product.images) do |image|
    json.name person.name
    json.age calculate_age(person.birthday)
  end
