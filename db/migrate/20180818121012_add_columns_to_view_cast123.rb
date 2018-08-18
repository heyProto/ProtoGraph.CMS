class AddColumnsToViewCast123 < ActiveRecord::Migration[5.1]
  def change
    add_column :pages, :cover_story_id, :integer
    add_column :pages, :image_narrative_id, :integer
  end
end
