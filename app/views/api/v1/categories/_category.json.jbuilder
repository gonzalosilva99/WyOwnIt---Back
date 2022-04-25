json.id category.id
json.name category.name
json.products category.products, partial: 'api/v1/products/product', as: :product
