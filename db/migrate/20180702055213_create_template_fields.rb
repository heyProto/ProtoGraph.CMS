class CreateTemplateFields < ActiveRecord::Migration[5.1]
  def change
    create_table :template_fields do |t|
      t.references :site, foreign_key: true
      t.references :template_datum, foreign_key: true
      t.string :key_name
      t.string :name
      t.string :data_type
      t.text :description
      t.text :help
      t.boolean :is_entry_title
      t.string :genre_html
      t.boolean :is_required, default: false
      t.string :default_value
      t.text :inclusion_list, array: true
      t.text :inclusion_list_names, array: true
      t.numeric :min
      t.numeric :max
      t.numeric :multiple_of
      t.boolean :ex_min
      t.boolean :ex_max
      t.text :format
      t.string :format_regex
      t.integer :length_minimum
      t.integer :length_maximum
      t.string :slug
      t.integer :created_by
      t.integer :updated_by
      t.timestamps
    end
  end
end
