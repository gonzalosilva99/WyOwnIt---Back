json.id user.id
json.email user.email
json.name user.name
json.lastname user.lastname
json.address user.address
json.unit_number user.unitnumber
json.deliveryinstructions user.deliveryinstructions
json.postal_code user.postal_code, partial: 'api/v1/postal_codes/postal_code', as: :postal_code