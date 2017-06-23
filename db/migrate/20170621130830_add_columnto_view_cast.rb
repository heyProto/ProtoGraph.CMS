class AddColumntoViewCast < ActiveRecord::Migration[5.1]
  def change
    add_column :view_casts, :seo_blockquote, :text
  end
end
