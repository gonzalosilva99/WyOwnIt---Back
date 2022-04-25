class Product < ApplicationRecord

  enum tag: [:starter, :intermediate, :delux, :pro]
  has_many :images
  accepts_nested_attributes_for :images, allow_destroy: true


  scope :filter_by_tag, -> (tag) { where tag: tag }
end
