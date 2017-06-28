class AddColsToViewCast < ActiveRecord::Migration[5.1]
  def change
    add_column :view_casts, :preview_image_url, :text
  end
end
