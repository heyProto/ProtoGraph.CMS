class AddColsToViewCasts < ActiveRecord::Migration[5.1]
  def change
    add_column :view_casts, :format, :string
    add_column :view_casts, :importance, :string, default: "low"
  end
end
