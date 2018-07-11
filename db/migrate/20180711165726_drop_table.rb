class DropTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :ref_link_sources
  end
end
