class CreateRefLinkSources < ActiveRecord::Migration[5.1]
  def change
    create_table :ref_link_sources do |t|
      t.string :name
      t.text :url
      t.text :favicon_url
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
