class AddColumnCreditToImages < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :credits, :string
    add_column :images, :credit_link, :text
  end
end
