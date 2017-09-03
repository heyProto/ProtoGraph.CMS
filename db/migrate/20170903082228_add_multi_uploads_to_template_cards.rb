class AddMultiUploadsToTemplateCards < ActiveRecord::Migration[5.1]
  def change
    add_column :template_cards, :has_multiple_uploads, :boolean, default: false
    a = TemplateCard.where(name: "toReportViolence").first
    a.has_multiple_uploads = true
    a.save
    b = TemplateCard.where(name: "toExplain").first
    b.has_multiple_uploads = true
    b.save
  end
end
