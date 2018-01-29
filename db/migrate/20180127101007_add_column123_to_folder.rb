class AddColumn123ToFolder < ActiveRecord::Migration[5.1]
  def change
    add_column :folders, :ref_category_vertical_id, :integer
  end
end
