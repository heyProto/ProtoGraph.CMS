class AddRowUploadedToUploads < ActiveRecord::Migration[5.1]
  def change
    add_column :uploads, :total_rows, :integer
    add_column :uploads, :rows_uploaded, :integer
  end
end
