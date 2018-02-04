class AddSortOrderToTemplateCards < ActiveRecord::Migration[5.1]
  def change
    add_column :template_cards, :sort_order, :integer
  end
end
