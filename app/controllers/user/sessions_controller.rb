class User::SessionsController < Devise::SessionsController
    layout "three_column_grid", only: [:new]

    def new
        @to_explain = TemplateCard.where(name: "toExplain", is_current_version: true).first
        @to_quiz = TemplateCard.where(name: "toQuiz", is_current_version: true).first
        @to_report_violence = TemplateCard.where(name: "toReportViolence", is_current_version: true).first
        @to_social = TemplateCard.where(name: "toSocial", is_current_version: true).first
        super
    end

end
