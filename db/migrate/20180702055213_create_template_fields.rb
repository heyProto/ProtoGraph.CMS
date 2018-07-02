class CreateTemplateFields < ActiveRecord::Migration[5.1]
  def change
    create_table :template_fields do |t|
      t.references :site, foreign_key: true
      t.references :template_datum, foreign_key: true
      t.string :name
      t.string :title
      t.string :data_type
      t.boolean :is_req, default: false
      t.string :default
      t.text :enum, array: true
      t.text :enum_names, array: true
      t.numeric :min
      t.numeric :max
      t.numeric :multiple_of
      t.boolean :ex_min
      t.boolean :ex_max
      t.string :format
      t.string :pattern
      t.integer :min_length
      t.integer :max_length
      t.string :slug
      t.timestamps
    end
  end
end
