class AddsColumnsToTables < ActiveRecord::Migration[5.1]
  def change
    add_column :template_cards, :is_editable, :boolean, default: true
    add_column :pages, :landing_card_id, :integer
  end
end
