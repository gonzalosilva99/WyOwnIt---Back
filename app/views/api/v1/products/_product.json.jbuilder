json.id product.id
json.name product.name
json.description product.description
json.tag product.tag
json.stock product.stock
json.images product.images, partial:'api/v1/images/image', as: :image
