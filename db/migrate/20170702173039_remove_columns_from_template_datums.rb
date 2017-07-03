class RemoveColumnsFromTemplateDatums < ActiveRecord::Migration[5.1]
  def change
    remove_column :template_data, :account_id
    remove_column :template_data, :elevator_pitch
    remove_column :template_data, :description
    remove_column :template_data, :is_current_version
    remove_column :template_data, :version_series
    remove_column :template_data, :previous_version_id
    remove_column :template_data, :version_genre
    remove_column :template_data, :status
    remove_column :template_data, :git_url
    remove_column :template_data, :git_branch
    remove_column :template_data, :created_by
    remove_column :template_data, :updated_by
    remove_column :template_data, :api_key
    remove_column :template_data, :is_public
  end
end