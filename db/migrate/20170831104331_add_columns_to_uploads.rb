class AddColumnsToUploads < ActiveRecord::Migration[5.1]
  def change
    add_reference :uploads, :account, foreign_key: true
    add_reference :uploads, :folder, foreign_key: true
    add_column :uploads, :created_by, :integer
    add_column :uploads, :updated_by, :integer
  end
end
