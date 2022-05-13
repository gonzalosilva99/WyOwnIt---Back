json.id order.id
json.created_date order.created_at.strftime("%Y-%m-%e")
json.created_time order.created_at.strftime("%H:%M")
json.updated_date order.updated_at.strftime("%Y-%m-%e")
json.updated_time order.updated_at.strftime("%H:%M")
json.status order.status
json.days order.days
json.order_products order.order_products, partial: 'api/v1/order_products/order_product', as: :order_product
json.delivery_notes order.delivery_notes
json.user order.user, partial: 'api/v1/users/user_with_shipping', as: :user
