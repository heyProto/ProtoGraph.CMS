class AddColumnToUploads < ActiveRecord::Migration[5.1]
  def change
    add_column :uploads, :site_id, :integer

    Upload.all.each do |upload|
        upload.update_column(:site_id, upload.account.site.id)
    end
  end
end
