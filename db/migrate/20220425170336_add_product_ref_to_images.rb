class AddProductRefToImages < ActiveRecord::Migration[7.0]
  def change
    add_reference :images, :product, null: false, foreign_key: true
  end
end
