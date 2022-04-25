class AddTagToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :tag, :integer
  end
end
