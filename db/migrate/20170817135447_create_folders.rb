class CreateFolders < ActiveRecord::Migration[5.1]
  def change
    create_table :folders do |t|
      t.integer :account_id
      t.string :name
      t.string :slug
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
