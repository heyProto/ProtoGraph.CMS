class AddUploadErrorsToUploads < ActiveRecord::Migration[5.1]
  def change
    add_column :uploads, :upload_errors, :text
  end
end
