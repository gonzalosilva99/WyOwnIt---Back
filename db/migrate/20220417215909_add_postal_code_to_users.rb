class AddPostalCodeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :postal_code, null: false, foreign_key: true
  end
end