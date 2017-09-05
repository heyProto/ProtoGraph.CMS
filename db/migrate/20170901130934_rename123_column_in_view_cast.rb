class Rename123ColumnInViewCast < ActiveRecord::Migration[5.1]
  def change
    rename_column :view_casts, :render_screenshot_url, :render_screenshot_key

    ViewCast.all.each do |view_cast|
        key = view_cast.render_screenshot_key.present? ? view_cast.render_screenshot_key.split('/')[-2..-1].join("/") : nil
        view_cast.update_column(:render_screenshot_key, key)
    end
  end
end
