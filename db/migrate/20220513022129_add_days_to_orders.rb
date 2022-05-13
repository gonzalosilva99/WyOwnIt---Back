class AddDaysToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :days, :integer
  end
end
