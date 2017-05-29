class AddMonthToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :month, :integer
  end
end
