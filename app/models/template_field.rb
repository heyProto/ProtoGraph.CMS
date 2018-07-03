class TemplateField < ApplicationRecord
    extend FriendlyId
    friendly_id :name, use: :slugged

    #ASSOCIATIONS
    belongs_to :template_datum

    #CALLBACKS
    before_save :before_save_set

    def before_save_set
        self.enum.reject!(&:blank?)
        self.enum_names.reject!(&:blank?)
        if %w(number integer).include?(self.data_type)
            self.format = nil
            self.pattern = nil
            self.min_length = nil
            self.max_length = nil
        elsif data_type == "string"
            self.min = nil
            self.max = nil
            self.multiple_of = nil
            self.ex_min = nil
            self.ex_max = nil
        elsif %w(array boolean)
            self.format = nil
            self.pattern = nil
            self.min_length = nil
            self.max_length = nil
            self.min = nil
            self.max = nil
            self.multiple_of = nil
            self.ex_min = nil
            self.ex_max = nil
        end
    end
end
