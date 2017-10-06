class AddColumnTo123123ViewCast < ActiveRecord::Migration[5.1]
  def change
    add_column :view_casts, :default_view, :string

    ViewCast.all.each do |view_cast|
        view_cast.update_column(:default_view, "laptop")
    end
  end
end
