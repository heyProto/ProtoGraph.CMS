class SessionsController < Devise::SessionsController

  def new
    @to_explain = TemplateCard.where(name: "toExplain", is_current_version: true).first
    @to_quiz = TemplateCard.where(name: "toQuiz", is_current_version: true).first
    @to_mob_justice = TemplateCard.where(name: "toMobJustice", is_current_version: true).first
    @to_social = TemplateCard.where(name: "toSocial", is_current_version: true).first
    super
  end

end