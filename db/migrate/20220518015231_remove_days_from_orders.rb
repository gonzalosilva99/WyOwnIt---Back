class RemoveDaysFromOrders < ActiveRecord::Migration[7.0]
  def change
    remove_column :orders, :days
  end
end
