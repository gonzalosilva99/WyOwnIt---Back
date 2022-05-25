class Product < ApplicationRecord

  enum tag: [:starter, :intermediate, :deluxe, :pro]
  validates :stock, :current_stock, :name, presence: true
  has_many :images
  belongs_to :category
  accepts_nested_attributes_for :images, allow_destroy: true
  has_many :images

  def self.order_by_ids(ids)
    order_by = ["case"]
    ids.each_with_index.map do |id, index|
      order_by << "WHEN id='#{id}' THEN #{index}"
    end
    order_by << "end"
    order(order_by.join(" "))
  end

  scope :filter_by_tag, -> (tag) { where tag: tag }
end
