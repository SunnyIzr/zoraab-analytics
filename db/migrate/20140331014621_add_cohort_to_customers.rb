class AddCohortToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :cohort, :integer
  end
end
