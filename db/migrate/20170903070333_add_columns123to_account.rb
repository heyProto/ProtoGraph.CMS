class AddColumns123toAccount < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :logo_url, :text
  end
end
