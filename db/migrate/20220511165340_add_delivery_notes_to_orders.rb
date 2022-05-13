class AddDeliveryNotesToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :delivery_notes, :string
  end
end
