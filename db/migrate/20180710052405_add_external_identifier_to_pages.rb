class AddExternalIdentifierToPages < ActiveRecord::Migration[5.1]
  def change
    add_column :pages, :external_identifier, :string
  end
end
