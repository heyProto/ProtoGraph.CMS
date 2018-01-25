class RemoveColumnFromViewCast < ActiveRecord::Migration[5.1]
  def change
    remove_column :view_casts, :render_screenshot_key
  end
end
