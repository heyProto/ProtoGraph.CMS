# == Schema Information
#
# Table name: template_fields
#
#  id                :integer          not null, primary key
#  site_id           :integer
#  template_datum_id :integer
#  name              :string
#  title             :string
#  data_type         :string
#  is_req            :boolean          default(FALSE)
#  default           :string
#  enum              :text             is an Array
#  enum_names        :text             is an Array
#  min               :decimal(, )
#  max               :decimal(, )
#  multiple_of       :decimal(, )
#  ex_min            :boolean
#  ex_max            :boolean
#  format            :string
#  pattern           :string
#  min_length        :integer
#  max_length        :integer
#  slug              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class TemplateField < ApplicationRecord
  
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  #CONCERNS
  #ASSOCIATIONS
  belongs_to :template_datum
  
  #ACCESSORS
  #VALIDATIONS
  #CALLBACKS
  before_save :before_save_set
  
  #SCOPE
  #OTHER

  private
  
  def before_save_set
      if self.enum.present? and self.enum_names.present?
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
    
end
