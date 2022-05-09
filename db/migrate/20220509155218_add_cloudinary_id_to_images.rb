class AddCloudinaryIdToImages < ActiveRecord::Migration[7.0]
  def change
    add_column :images, :cloudinary_id, :string
  end
end
