# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
PostalCode.create(code: 'K0E 0A0', place_name: "Ontario Average")
Admin.create!(email: 'admin@gmail.com', password:'password', password_confirmation: 'password', name:'Admin', postal_code: PostalCode.first)
Customer.create!(email: 'customer@gmail.com', password:'password', password_confirmation: 'password', name:'Customer', postal_code: PostalCode.first)
Admin.create(email: 'rafaschol11@gmail.com', password:'password', password_confirmation: 'password', name:'Customer', postal_code: PostalCode.first)
Admin.create( email: 'noah.roelofsen@icloud.com',password:'password', password_confirmation: 'password', name:'Customer', postal_code: PostalCode.first)
Admin.create(email: 'wyownit@gmail.com', password:'password', password_confirmation: 'password', name:'Customer', postal_code: PostalCode.first)
