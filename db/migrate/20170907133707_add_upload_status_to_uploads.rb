class AddUploadStatusToUploads < ActiveRecord::Migration[5.1]
  def change
    add_column :uploads, :upload_status, :string, default: "waiting"
  end
end
