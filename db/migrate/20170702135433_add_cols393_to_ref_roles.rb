class AddCols393ToRefRoles < ActiveRecord::Migration[5.1]
  def change
    add_column :ref_roles, :sort_order, :integer
  end
end
