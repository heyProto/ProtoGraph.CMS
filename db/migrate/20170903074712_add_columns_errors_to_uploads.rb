class AddColumnsErrorsToUploads < ActiveRecord::Migration[5.1]
  def change
    add_column :uploads, :filtering_errors, :text
  end
end
