# == Schema Information
#
# Table name: ref_link_sources
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  url         :text(65535)
#  favicon_url :text(65535)
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class RefLinkSource < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  belongs_to :creator, class_name: "User", foreign_key: "created_by"
  belongs_to :updator, class_name: "User", foreign_key: "updated_by"
  #ACCESSORS
  #VALIDATIONS
  validates :name, presence: true, uniqueness: true
  validates :favicon_url, presence: true, uniqueness: {scope: :name}
  validates :url, presence: true, uniqueness: {scope: [:name, :favicon_url]}
  #CALLBACKS
  #SCOPE
  #OTHER
  def as_json
    {
      name: name,
      url: url,
      favicon_url: favicon_url
    }
  end

  def self.publish
    ref_link_sources = RefLinkSource.all.as_json
    response = Api::ProtoGraph::Utility.upload_to_cdn(Base64.encode64(ref_link_sources.to_json), "Assets/ref_link_sources.json", "application/json")
    invalidate = Api::ProtoGraph::CloudFront.invalidate(items=["/Assets/ref_link_sources.json"], quantity=1)
    if response[0]["s3_endpoint"].present? and invalidate["success"]
      return true
    else
      return false
    end
  end
  #PRIVATE
end
