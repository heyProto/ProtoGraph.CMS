class RenameColumninViewCast < ActiveRecord::Migration[5.1]
  def change
    rename_column :view_casts, :configJSON, :optionalConfigJSON
  end
end
