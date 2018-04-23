class ChangeNameHtmlInVertical < ActiveRecord::Migration[5.1]
  def change
    change_column :ref_categories, :name_html, :text
  end
end
