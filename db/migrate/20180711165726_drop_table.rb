class DropTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :ref_link_sources
    drop_table :taggings
    add_column :template_pages, :site_id, :integer
    add_column :template_pages, :is_system, :boolean, default: false
    add_column :template_cards, :is_system, :boolean, default: false
  end
end
