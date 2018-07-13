class AddExternalIdentifierToViewCasts < ActiveRecord::Migration[5.1]
  def change
    add_column :view_casts, :external_identifier, :string
  end
end
