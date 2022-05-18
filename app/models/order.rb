class Order < ApplicationRecord
    enum status: [:pending, :approved, :denied, :delivering, :delivered, :completed]
    belongs_to :user
    has_many :order_products
    has_many :products, through: :order_products
    accepts_nested_attributes_for :order_products, allow_destroy: true
end
