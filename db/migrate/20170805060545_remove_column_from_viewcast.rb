class RemoveColumnFromViewcast < ActiveRecord::Migration[5.1]
  def change
    remove_column :view_casts, :cdn_url
  end
end
