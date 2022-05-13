json.id order.id
json.created_date order.created_at.strftime("%e/%m/%Y")
json.created_time order.created_at.strftime("%H:%M")
json.status order.status
json.days order.days
json.order_products order.order_products, partial: 'api/v1/order_products/order_product', as: :order_product
