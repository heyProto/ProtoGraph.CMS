class AddsNameToStream < ActiveRecord::Migration[5.1]
  def change
    add_column :page_streams, :name_of_stream, :string
    rename_column :pages, :meta_tags, :meta_keywords
  end
end
