class AddTypeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :trans_type, :string
  end
end
