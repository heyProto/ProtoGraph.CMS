# == Schema Information
#
# Table name: stream_entities
#
#  id           :integer          not null, primary key
#  stream_id    :integer
#  entity_type  :string(255)
#  entity_value :string(255)
#  is_excluded  :boolean
#  created_by   :integer
#  updated_by   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  sort_order   :integer
#

class StreamEntity < ApplicationRecord
    #CONSTANTS
    #CUSTOM TABLES
    #GEMS
    #CONCERNS
    include AssociableBy
    #ASSOCIATIONS
    belongs_to :stream
    #ACCESSORS
    attr_accessor :page_id, :remove_stream_entity_id
    #VALIDATIONS
    validates :entity_type, presence: true
    validates :entity_value, presence: true, uniqueness: {scope: [:entity_type, :stream_id]}
    #CALLBACKS
    before_save :before_save_set
    before_create :set_sort_order
    after_create :after_create_set
    before_destroy :before_destroy_set
    #SCOPE
    scope :folders, -> {where(entity_type: "folder_id")}
    scope :template_cards, -> {where(entity_type: "template_card_id")}
    scope :view_casts, -> {where(entity_type: "view_cast_id", is_excluded: false).order(:sort_order)}
    scope :excluded_view_casts, -> {where(entity_type: "view_cast_id", is_excluded: true)}
    #OTHER

    def next
        a = self.stream.view_cast_ids.where("sort_order > ?", self.sort_order).order(:sort_order).first
    end

    def previous
        a = self.stream.view_cast_ids.where("sort_order < ?", self.sort_order).order(sort_order: :desc).last
    end

    #PRIVATE
    private

    def before_destroy_set
        self.stream.update_card_count
        if Rails.env.production? and ENV['SKIP_INVALIDATION'] != "true"
            self.stream.pages.each do |p|
                PagePublisher.perform_async(p.id)
            end
        end
    end

    def before_save_set
        self.is_excluded = false if self.is_excluded.blank?
    end

    def after_create_set
        if self.remove_stream_entity_id.present?
            StreamEntity.where(id: remove_stream_entity_id).destroy_all
        end
    end

    def set_sort_order
        if stream.title.split[1] != "Section"
            if self.sort_order.blank?
                if self.stream.title == "#{self.page_id}_Story_Narrative"
                    # Don't do anything here if the card is coverstory and sort_order is -1
                    last_view_cast = stream.view_cast_ids.order(sort_order: :desc).last
                    self.sort_order = last_view_cast.present? ? last_view_cast.sort_order.to_i + 1 : 1
                else
                    stream.view_cast_ids.update_all("sort_order = sort_order + 1")
                    self.sort_order = 1
                end
            end
        end
    end
end
