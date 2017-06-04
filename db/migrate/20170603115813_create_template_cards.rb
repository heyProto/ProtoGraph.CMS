  class CreateTemplateCards < ActiveRecord::Migration[5.1]
    def change
      create_table :template_data do |t|
        t.integer :account_id
        t.string :name
        t.text :description
        t.string :slug
        t.string :status
        t.string :api_key
        t.integer :publish_count
        t.boolean :is_public
        t.integer :created_by
        t.integer :updated_by

        t.timestamps
      end
      add_index :template_data, :slug, unique: true
      add_index :template_data, :api_key, unique: true

      create_table :template_cards do |t|
        t.integer :account_id
        t.integer :template_datum_id
        t.string :name
        t.text :description
        t.string :slug
        t.string :status
        t.integer :publish_count
        t.boolean :is_public
        t.integer :created_by
        t.integer :updated_by

        t.timestamps
      end
      add_index :template_cards, :slug, unique: true
      create_table :template_streams do |t|
        t.integer :account_id
        t.string :name
        t.text :description
        t.string :slug
        t.string :status
        t.integer :publish_count
        t.boolean :is_public
        t.integer :created_by
        t.integer :updated_by

        t.timestamps
      end
      add_index :template_streams, :slug, unique: true

      create_table :template_stream_cards do |t|
        t.integer :account_id
        t.integer :template_card_id
        t.integer :template_stream_id
        t.boolean :is_mandatory
        t.integer :position
        t.integer :created_by
        t.integer :updated_by

        t.timestamps
      end

      create_table :services_attachables do |t|
        t.integer :account_id
        t.integer :attachable_id
        t.string :attachable_type
        t.string :genre
        t.text :file_url
        t.text :original_file_name
        t.string :file_type
        t.string :s3_bucket
        t.integer :created_by
        t.integer :updated_by

        t.timestamps
      end
      add_index "services_attachables", [:attachable_id, :attachable_type]

    end
  end
