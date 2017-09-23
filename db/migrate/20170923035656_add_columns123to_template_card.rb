class AddColumns123toTemplateCard < ActiveRecord::Migration[5.1]
  def change
    add_column :template_cards, :allowed_views, :text

    TemplateCard.all.each do |card|
        card.allowed_views = ["mobile", "laptop"]
        card.allowed_views << "list" if card.name == "toLink"
        card.save
    end
  end
end