class AddSiteIdToTemplateDatum < ActiveRecord::Migration[5.1]
  def change
    add_column :template_data, :site_id, :integer
  end
end
