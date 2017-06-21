class AddColsToTemplateCard < ActiveRecord::Migration[5.1]
  def change
    add_column :template_cards, :has_static_image, :boolean, default: false

    TemplateCard.where(name: "ProtoGraph.Card.toBrandAnIntersection").update_all(has_static_image: true)
  end
end
