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
  #CONCERNS
  include AssociableBy
  #ASSOCIATIONS
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
    response = Api::ProtoGraph::Utility.upload_to_cdn(Base64.encode64(ref_link_sources.to_json), "Assets/ref_link_sources.json", "application/json",ENV['AWS_S3_BUCKET'])
    invalidate = Api::ProtoGraph::CloudFront.invalidate(site=nil, items=["/Assets/ref_link_sources.json"], quantity=1)
    if response[0]["s3_endpoint"].present? and invalidate["success"]
      return true
    else
      return false
    end
  end
  #PRIVATE
end
