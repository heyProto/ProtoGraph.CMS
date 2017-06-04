class AddDomainToAccount < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :gravatar_email, :string
  end
end
