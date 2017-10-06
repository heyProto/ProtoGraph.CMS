class AddErrorsToUploads < ActiveRecord::Migration[5.1]
  def change
    add_column :uploads, :validation_errors, :text
  end
end
