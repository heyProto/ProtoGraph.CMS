class AddCols1234InViewCast < ActiveRecord::Migration[5.1]
  def change
    add_column :view_casts, :status, :text
  end
end
