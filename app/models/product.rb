class Product < ApplicationRecord

  has_many_attached :images

  validates :images,
    content_type: %i(gif png jpg jpeg),                        #Image type
    size: { less_than_or_equal_to: 5.megabytes },              #file size
    dimension: { width: { max: 2000 }, height: { max: 2000 } }
end
