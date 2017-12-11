# == Schema Information
#
# Table name: audio_variations
#
#  id                 :integer          not null, primary key
#  audio_id           :string(255)
#  integer            :string(255)
#  start_time         :integer
#  end_time           :integer
#  is_original        :boolean
#  total_time         :integer
#  subtitle_file_path :string(255)
#  created_by         :integer
#  updated_by         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  audio_key          :text(65535)
#

class AudioVariation < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  delegate :account, to: :audio
  belongs_to :audio
  #ACCESSORS
  #VALIDATIONS
  #CALLBACKS
  after_commit :process_and_upload_audio, if: :is_original?, on: [:create]
  after_commit :process_and_upload_audio_variation, if: :not_is_original?, on: [:create]
  #SCOPE
  #OTHER
  def audio_url
    "#{account.cdn_endpoint}/#{audio_key}"
  end

  def process_and_upload_audio
    require "base64"
    audio = self.audio

    audio_path = CGI.unescape "#{Rails.root.to_s}/public#{audio.audio.url}"

    data = {
      audioVariationId: id,
      s3Identifier: audio.s3_identifier,
      accountSlug: account.slug,
      audioBlob: Base64.encode64(File.open(audio_path, "rb").read()),
      startTime: nil,
      endTime: nil
    }

    url = "#{AWS_API_DATACAST_URL}/audios"
    response = RestClient.post(url, data.to_json, {
      content_type: :json,
      accept: :json,
      "x-api-key" => ENV['AWS_API_KEY']
    })

    response = JSON.parse(response);
    self.update_attribute(
      {
        audio_key: response["data"]["audio_key"]
      }
    )
  end

  def is_original?
    return is_original
  end

  def not_is_original?
    return !is_original
  end
  #PRIVATE
end
