class CreateTemplateContainers < ActiveRecord::Migration[5.1]
  def change
    create_table :template_containers do |t|
      t.integer :account_id
      t.string :name
      t.string :elevator_pitch
      t.text :description
      t.string :global_slug
      t.boolean :is_current_version
      t.string :slug
      t.string :version_series
      t.integer :previous_version_id
      t.string :version_genre
      t.string :version
      t.text :change_log
      t.string :status
      t.integer :publish_count
      t.boolean :is_public
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
