class AddMultiUploadsToTemplateCards < ActiveRecord::Migration[5.1]
  def change
    add_column :template_cards, :has_multiple_uploads, :boolean, default: false
  end
end
