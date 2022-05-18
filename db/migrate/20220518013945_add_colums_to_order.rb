class AddColumsToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :start_date, :datetime
    add_column :orders, :end_date, :datetime
  end
end
