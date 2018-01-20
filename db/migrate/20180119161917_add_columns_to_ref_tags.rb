class AddColumnsToRefTags < ActiveRecord::Migration[5.1]
  def change
    add_column :ref_tags, :stream_url, :text
    add_column :ref_tags, :stream_id, :integer
    add_column :ref_tags, :is_disabled, :boolean
    add_column :ref_tags, :created_by, :boolean
    add_column :ref_tags, :updated_by, :boolean
    add_column :ref_tags, :count, :integer, default: 0
  end
end
