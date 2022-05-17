class Product < ApplicationRecord

  enum tag: [:starter, :intermediate, :deluxe, :pro]
  validates :stock, :current_stock, :name, presence: true
  has_many :images
  belongs_to :category
  accepts_nested_attributes_for :images, allow_destroy: true
  has_many :images


  scope :filter_by_tag, -> (tag) { where tag: tag }
end
