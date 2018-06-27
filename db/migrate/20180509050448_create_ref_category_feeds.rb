class CreateRefCategoryFeeds < ActiveRecord::Migration[5.1]
  def change
    create_table :feeds do |t|
      t.integer :ref_category_id
      t.text :rss
      t.datetime :last_refreshed_at
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    create_table :feed_links do |t|
      t.integer :ref_category_id
      t.integer :feed_id
      t.integer :view_cast_id
      t.text :link
      t.text :headline
      t.datetime :published_at
      t.text :description
      t.text :cover_image
      t.string :author
      t.timestamps
    end
  end
end
