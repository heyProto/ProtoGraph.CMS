class AddCols123ToViewCasts < ActiveRecord::Migration[5.1]
  def change
    add_column :view_casts, :is_invalidating, :boolean
  end
end
