class AddColumnToTemplateCards < ActiveRecord::Migration[5.1]
  def change
    add_column :template_cards, :git_repo_name, :string
  end
end
