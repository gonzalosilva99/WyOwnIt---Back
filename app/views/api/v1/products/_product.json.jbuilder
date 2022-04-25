json.id product.id
json.name product.name
json.description product.description
json.tag product.tag
json.stock product.stock
json.current_stock product.current_stock
json.category product.category, partial: 'api/v1/categories/category_without_product', as: :category
json.images product.images, partial:'api/v1/images/image', as: :image
