class DropTableRefTags < ActiveRecord::Migration[5.1]
  def change
    drop_table :ref_tags
  end
end
