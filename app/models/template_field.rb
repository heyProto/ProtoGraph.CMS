# == Schema Information
#
# Table name: template_fields
#
#  id                   :integer          not null, primary key
#  site_id              :integer
#  template_datum_id    :integer
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
#  sort_order           :integer
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
  after_save :after_save_set
  after_commit :fix_sort_order

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
    true
  end

  def after_save_set
    template_datum = self.template_datum
    template_datum.upload_to_s3
    puts "after_save_set end"
    true
  end

  def fix_sort_order
    puts "-----------------fix sort order---------------------"
    if saved_change_to_sort_order?
      template_fields_to_fix = TemplateField.where(template_datum_id: self.template_datum_id).where("sort_order >= ?", self.sort_order).where.not(id: self.id).order("sort_order").to_a
      # if template_fields_to_fix.count > 0
      #   template_fields_to_fix.each do |tf|
      #     sort_order = sort_order + 1
      #     tf.update_column(:sort_order, sort_order)
      #   end
      # end
      n = template_fields_to_fix.length
      if n > 0
        tf = template_fields_to_fix[0]
        puts "index=self, sort_order=#{self.sort_order}|index=0, sort_order=#{tf.sort_order}"
        if self.sort_order == tf.sort_order
          tf.update_column(:sort_order, tf.sort_order+1)
          # tf.sort_order = tf.sort_order + 1
          template_fields_to_fix[0] = tf
        end
        i = 0
        while i < n-1
          tf = template_fields_to_fix[i]
          next_tf = template_fields_to_fix[i+1]
          puts "index=#{i}, sort_order=#{tf.sort_order}|index=#{i+1}, sort_order=#{next_tf.sort_order}"
          if tf.sort_order == next_tf.sort_order
            next_tf.update_column(:sort_order, next_tf.sort_order+1)
            # next_tf.sort_order = next_tf.sort_order+1
            template_fields_to_fix[i+1] = next_tf
          end
          i=i+1
        end
      end
    end
    true
  end
end
