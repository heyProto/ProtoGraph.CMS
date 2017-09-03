class CsvVerificationWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => true

  def perform(upload_id)
    @upload = Upload.find(upload_id)
    require 'csv'
    # The last jq filter returns an array of json objects
    begin
      card_array_filtered = %x(csv2json #{@upload.attachment.file.file} | jq -f ref/jq_filter/jq_filter_#{@upload.template_card.name}.jq | jq -s '.')
    rescue
      next
    end
    card_array_filtered = JSON.parse(card_array_filtered)
    schema = JSON.parse(RestClient.get(@upload.template_card.template_datum.schema_json))
    @upload.upload_errors = "[]"
    @upload.save
    card_array_filtered.each do |card_filtered|
      upload_card(@upload.id, card_filtered, "name", "seo_blockquote_text", "source")
    end
  end

  def upload_card(upload_id, card_data, name, seo_blockquote_text, source)
    @upload = Upload.find(upload_id)
    payload = {}
    params = all_params(card_data, name, seo_blockquote_text, source)
    datacast_params = params[:datacast]
    payload["payload"] = datacast_params.to_json
    payload["source"]  = params[:source] || "form"
    view_cast_params = params[:view_cast]
    view_cast = @upload.folder.view_casts.new(view_cast_params)
    view_cast.account_id = @upload.account.id
    view_cast.created_by = @upload.creator.id
    view_cast.updated_by = @upload.updator.id
    if view_cast.save
      payload["api_slug"] = view_cast.datacast_identifier
      payload["schema_url"] = view_cast.template_datum.schema_json
      r = Api::ProtoGraph::Datacast.create(payload)
      if r.has_key?("errorMessage")
        view_cast.destroy
        upload_error = [r['errorMessage']]
      end
    else
      upload_error =  [view_cast.errors.full_messages]
    end
    if upload_error.nil?
      upload_error = []
    end
    upload_errors = JSON.parse(@upload.upload_errors)
    upload_errors << upload_error
    @upload.upload_errors = upload_errors.to_json.to_s
    @upload.save
  end
  
  def all_params(card_data, name, seo_blockquote_text, source)
    {
      datacast: card_data,
      view_cast: {
        account_id: @account,
        template_datum_id: @upload.template_card.template_datum.id,
        name: name,
        template_card_id: @upload.template_card.id,
        seo_blockquote: "<blockquote><h3>#{name}</h3><p>#{seo_blockquote_text}</p></blockquote>",
        optionalConfigJSON: "{}",
        # source: source
      }
    }
  end
end
