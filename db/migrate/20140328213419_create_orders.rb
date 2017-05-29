class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.timestamps
      t.string :number
      t.float :total
      t.belongs_to :customer
    end
  end
end
