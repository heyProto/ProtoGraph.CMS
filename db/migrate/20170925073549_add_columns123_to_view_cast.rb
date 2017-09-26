class AddColumns123ToViewCast < ActiveRecord::Migration[5.1]
  def change
    add_column :view_casts, :article_id, :integer
  end
end
