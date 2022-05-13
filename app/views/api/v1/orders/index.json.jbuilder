# json.array! @orders, partial: 'order_index', as: :order
json.data @orders, partial: 'order_index', as: :order
json.count @orders.count