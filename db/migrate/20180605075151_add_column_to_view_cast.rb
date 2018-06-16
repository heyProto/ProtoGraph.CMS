class AddColumnToViewCast < ActiveRecord::Migration[5.1]
  def change
    add_column :view_casts, :data_json, :json
  end
end
