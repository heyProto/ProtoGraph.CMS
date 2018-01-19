class CreatePages < ActiveRecord::Migration[5.1]
  def change
    create_table :pages do |t|
      t.integer :account_id
      t.integer :site_id
      t.integer :folder_id
      t.string :headline
      t.string :meta_tags
      t.text :meta_description
      t.text :summary
      t.string :layout
      t.string :byline
      t.string :byline_stream
      t.text :cover_image_url
      t.text :cover_image_url_7_column
      t.text :cover_image_url_facebook
      t.text :cover_image_url_square
      t.string :cover_image_alignment
      t.boolean :is_sponsored
      t.boolean :is_interactive
      t.boolean :has_data
      t.boolean :has_image_other_than_cover
      t.boolean :has_audio
      t.boolean :has_video
      t.boolean :is_published
      t.datetime :published_at
      t.text :url
      t.integer :ref_category_series_id
      t.integer :ref_category_intersection_id
      t.integer :ref_category_sub_intersection_id
      t.integer :view_cast_id
      t.text :page_object_url
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
