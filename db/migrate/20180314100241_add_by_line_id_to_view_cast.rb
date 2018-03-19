class AddByLineIdToViewCast < ActiveRecord::Migration[5.1]
  def change
    add_column :view_casts, :byline_id, :integer
  end
end
