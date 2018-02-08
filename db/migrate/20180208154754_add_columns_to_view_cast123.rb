class AddColumnsToViewCast123 < ActiveRecord::Migration[5.1]
  def change
    add_column :view_casts, :is_disabled_for_edit, :boolean, default: false

    template_cards = TemplateCard.where(name: ['toExplain', "Silenced: toReportJournalistMurder", "toArticle", "JalJagran: toDistrictProfile", "JalJagran: toRainfall", "JalJagran: toPoliticalLeadership", "JalJagran: toLandUse", "JalJagran: toWaterExploitation", "toQuiz", "toTimeline"]).pluck(:id)
    ViewCast.where(template_card_id: template_cards).update_all(is_disabled_for_edit: true)
  end
end
