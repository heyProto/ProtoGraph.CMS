# == Schema Information
#
# Table name: tags
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  taggings_count :integer          default(0)
#

class ActsAsTaggableOn::Tag < ApplicationRecord
  include SearchCop

  search_scope :search do
    attributes :name
  end

end
