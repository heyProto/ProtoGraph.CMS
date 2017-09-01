class RemoveValidationErrorsFromUploads < ActiveRecord::Migration[5.1]
  def change
    remove_column :uploads, :validation_errors
  end
end
