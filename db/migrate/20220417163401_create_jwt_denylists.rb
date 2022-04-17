class CreateJwtDenylists < ActiveRecord::Migration[7.0]
  def change
    create_table :jwt_denylist do |table|
      table.string :jti, null: false
      table.datetime :exp, null: false
    end
    add_index :jwt_denylist, :jti
  end
end
