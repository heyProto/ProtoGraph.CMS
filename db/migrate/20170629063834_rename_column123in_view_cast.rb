class RenameColumn123inViewCast < ActiveRecord::Migration[5.1]
  def change
    rename_column :view_casts, :preview_image_url,:render_screenshot_url
  end
end
