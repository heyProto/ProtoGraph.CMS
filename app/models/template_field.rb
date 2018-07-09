# == Schema Information
#
# Table name: template_fields
#
#  id                   :bigint(8)        not null, primary key
#  site_id              :bigint(8)
#  template_datum_id    :bigint(8)
#  key_name             :string
#  name                 :string
#  data_type            :string
#  description          :text
#  help                 :text
#  is_entry_title       :boolean
#  genre_html           :string
#  is_required          :boolean          default(FALSE)
#  default_value        :string
#  inclusion_list       :text             is an Array
#  inclusion_list_names :text             is an Array
#  min                  :decimal(, )
#  max                  :decimal(, )
#  multiple_of          :decimal(, )
#  ex_min               :boolean
#  ex_max               :boolean
#  format               :text
#  format_regex         :string
#  length_minimum       :integer
#  length_maximum       :integer
#  slug                 :string
#  created_by           :integer
#  updated_by           :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null

require 'json'
require 'open-uri'

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
  after_save :after_save_set

  #SCOPE
  #OTHER

  def before_save_set
    self.inclusion_list.reject!(&:blank?) if self.inclusion_list.present?
    self.inclusion_list_names.reject!(&:blank?) if self.inclusion_list_names.present?
    if %w(integer decimal).include?(self.data_type)
      self.format = nil
      self.format_regex = nil
      self.length_minimum = nil
      self.length_maximum = nil
    elsif %w(short_text long_text temporal).include?(self.data_type)
      self.min = nil
      self.max = nil
      self.multiple_of = nil
      self.ex_min = nil
      self.ex_max = nil
      if self.data_type == "long_text"
        self.format = nil
      end
    elsif %w(array object boolean).include?(self.data_type)
      if data_type != "boolean"
        self.format = nil
      end
      self.format_regex = nil
      self.length_minimum = nil
      self.length_maximum = nil
      self.min = nil
      self.max = nil
      self.multiple_of = nil
      self.ex_min = nil
      self.ex_max = nil
    end
  end

  def after_save_set
    template_datum = self.template_datum
    template_datum.upload_to_s3
    puts "after_save_set end"
  end
end
