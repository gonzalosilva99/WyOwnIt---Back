json.id order.id
json.created_date order.created_at.strftime("%e/%m/%Y")
json.created_time order.created_at.strftime("%H:%M")
json.updated_date order.updated_at.strftime("%e/%m/%Y")
json.updated_time order.updated_at.strftime("%H:%M")
json.status order.status
json.days order.days 
json.user order.user, partial: 'api/v1/users/user', as: :user
