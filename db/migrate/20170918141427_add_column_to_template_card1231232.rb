class AddColumnToTemplateCard1231232 < ActiveRecord::Migration[5.1]
  def change
    add_column :template_cards, :has_grouping, :boolean, default: false

    TemplateCard.where(name: ["toPoliticalLeadership", "toWaterExploitation"]).each do |d|
        d.update_column(:has_grouping, true)
    end
  end
end