class CreateTemplatePages < ActiveRecord::Migration[5.1]
  def change
    create_table :template_pages do |t|
      t.string  :name
      t.text    :description
      t.text    :global_slug
      t.boolean :is_current_version
      t.string  :slug
      t.string  :version_series
      t.integer :previous_version_id
      t.string  :version_genre
      t.string  :version
      t.text    :change_log
      t.string  :status
      t.integer :publish_count
      t.boolean :is_public
      t.string  :git_url
      t.string  :git_branch
      t.string  :git_repo_name
      t.string  :s3_identifier
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
