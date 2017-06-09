class RenameColumnInDatacast < ActiveRecord::Migration[5.1]
  def change
    rename_column :datacasts, :data, :cdn_url
  end
end
