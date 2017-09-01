class CardUploadWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => true

  def perform(upload_id, card_data, name, seo_blockquote_text, source)
    @upload = Upload.find(upload_id)
    @upload_errors = JSON.parse(@upload.upload_errors)
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
        @upload_errors << [r['errorMessage']]
      end
    else
      @upload_errors <<  [view_cast.errors.full_messages]
    end
    @upload.upload_errors = @upload_errors.to_json.to_s
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
