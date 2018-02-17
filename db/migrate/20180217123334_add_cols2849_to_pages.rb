class AddCols2849ToPages < ActiveRecord::Migration[5.1]
  def change
    add_column :pages, :due, :date
    add_column :pages, :description, :text
    add_column :pages, :cover_image_id_4_column, :integer
    add_column :pages, :cover_image_id_3_column, :integer
    add_column :pages, :cover_image_id_2_column, :integer
    add_column :pages, :cover_image_credit, :string
    add_column :pages, :share_text_facebook, :text
    add_column :pages, :share_text_twitter, :text
    add_column :pages, :one_line_concept, :string
    remove_column :pages, :byline_stream, :string
    
    create_table :page_todos do |t|
      t.integer :page_id
      t.integer :user_id
      t.integer :template_card_id
      t.text :task
      t.boolean :is_completed
      t.integer :sort_order
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    
  end
end
