json.id order.id
json.created_date order.created_at.strftime("%Y-%m-%d")
json.created_time order.created_at.strftime("%H:%M")
json.updated_date order.updated_at.strftime("%Y-%m-%d")
json.updated_time order.updated_at.strftime("%H:%M")
json.status order.status
json.start_date order.start_date.strftime("%Y-%m-%d") if order.start_date
json.end_date order.end_date.strftime("%Y-%m-%d") if order.end_date
json.order_products order.order_products, partial: 'api/v1/order_products/order_product', as: :order_product
json.user order.user, partial: 'api/v1/users/user', as: :user

