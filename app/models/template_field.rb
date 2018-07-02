class TemplateField < ApplicationRecord
    extend FriendlyId
    friendly_id :name, use: :slugged

    #ASSOCIATIONS
    belongs_to :template_datum
end
