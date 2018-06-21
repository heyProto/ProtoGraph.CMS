class AddSiteIdToTemplateCards < ActiveRecord::Migration[5.1]
  def change
    add_reference :template_cards, :site, foreign_key: true
  end
end
