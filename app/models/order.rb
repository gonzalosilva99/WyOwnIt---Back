class Order < ApplicationRecord
    enum status: [:pending, :approved, :denied, :delivering, :delivered]
    belongs_to :user
    has_many :order_products
    has_many :products, through: :order_products
    accepts_nested_attributes_for :order_products, allow_destroy: true
    validates :days, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 3 }
    validates :days, presence: true
end
