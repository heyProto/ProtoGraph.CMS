class AddUniquenessToViewCasts < ActiveRecord::Migration[5.1]
  def change
    add_index :view_casts, :slug, unique: true
  end
end
