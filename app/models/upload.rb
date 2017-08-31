# == Schema Information
#
# Table name: uploads
#
#  id                :integer          not null, primary key
#  attachment        :string(255)
#  template_card_id  :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  validation_errors :text(65535)
#  account_id        :integer
#  folder_id         :integer
#  created_by        :integer
#  updated_by        :integer
#  upload_errors     :text(65535)
#

class Upload < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  belongs_to :template_card
  belongs_to :folder
  include Associable
  #ACCESSORS
  attr_accessor :account_id, :folder_id, :user_id
  mount_uploader :attachment, CsvUploader
  #VALIDATIONS
  validates :attachment, presence: true
  validates :folder, presence: true
  #CALLBACKS
  after_create :validate_csv
  #SCOPE
  #OTHER
  @upload_errors = []
  def validate_csv
    require 'csv'
    errors = []
    # The last jq filter returns an array of json objects
    card_array_filtered = %x(csv2json #{self.attachment.file.file} | jq -f jq_filter.jq | jq -s '.')
    card_array_filtered = JSON.parse(card_array_filtered)
    schema = JSON.parse(RestClient.get(self.template_card.template_datum.schema_json))
    # url = "#{AWS_API_DATACAST_URL}/pub/validate-json"
    card_array_filtered.each do |card_filtered|
      error = JSON::Validator.fully_validate(schema, card_filtered)
      if error.empty?
        create_card(card_filtered, "name", "seo_blockquote_text", "source")
      end
      errors << error
    end
    self.validation_errors = errors.to_json.to_s
    self.upload_errors = @upload_errors.to_json.to_s
    self.save
  end

  def create_card(card_data, name, seo_blockquote_text, source)
    payload = {}
    params = all_params(card_data, name, seo_blockquote_text, source)
    datacast_params = params[:datacast]
    payload["payload"] = datacast_params.to_json
    payload["source"]  = params[:source] || "form"
    view_cast_params = params[:view_cast]
    view_cast = self.folder.view_casts.new(view_cast_params)
    view_cast.account_id = self.account.id
    view_cast.created_by = self.creator.id
    view_cast.updated_by = self.updator.id
    if view_cast.save
      payload["api_slug"] = view_cast.datacast_identifier
      payload["schema_url"] = view_cast.template_datum.schema_json
      r = Api::ProtoGraph::Datacast.create(payload)
      if r.has_key?("errorMessage")
        view_cast.destroy
        @upload_errors << [r['errorMessage']]
      else
        # render json: {view_cast: view_cast.as_json(methods: [:remote_urls]), redirect_path: account_folder_view_cast_url(@account, @folder, view_cast) }, status: 200
      end
    else
      @upload_errors <<  [view_cast.errors.full_messages]
    end
  end

  def all_params(card_data, name, seo_blockquote_text, source)
    {
      datacast: card_data,
      view_cast: {
        account_id: @account,
        template_datum_id: self.template_card.template_datum.id,
        name: name,
        template_card_id: self.template_card.id,
        seo_blockquote: "<blockquote><h3>#{name}</h3><p>#{seo_blockquote_text}</p></blockquote>",
        optionalConfigJSON: "{}",
        # source: source
      }
    }
  end
  #PRIVATE
end

