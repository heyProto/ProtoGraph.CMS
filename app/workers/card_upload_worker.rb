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
        template_datum_id: self.template_card.template_datum.id,
        name: name,
        template_card_id: self.template_card.id,
        seo_blockquote: "<blockquote><h3>#{name}</h3><p>#{seo_blockquote_text}</p></blockquote>",
        optionalConfigJSON: "{}",
        # source: source
      }
    }
  end
end

  # def create_card(card_data, name, seo_blockquote_text, source)
  #   payload = {}
  #   params = all_params(card_data, name, seo_blockquote_text, source)
  #   datacast_params = params[:datacast]
  #   payload["payload"] = datacast_params.to_json
  #   payload["source"]  = params[:source] || "form"
  #   view_cast_params = params[:view_cast]
  #   view_cast = self.folder.view_casts.new(view_cast_params)
  #   view_cast.account_id = self.account.id
  #   view_cast.created_by = self.creator.id
  #   view_cast.updated_by = self.updator.id
  #   if view_cast.save
  #     payload["api_slug"] = view_cast.datacast_identifier
  #     payload["schema_url"] = view_cast.template_datum.schema_json
  #     r = Api::ProtoGraph::Datacast.create(payload)
  #     if r.has_key?("errorMessage")
  #       view_cast.destroy
  #       @upload_errors << [r['errorMessage']]
  #     else
  #       # render json: {view_cast: view_cast.as_json(methods: [:remote_urls]), redirect_path: account_folder_view_cast_url(@account, @folder, view_cast) }, status: 200
  #     end
  #   else
  #     @upload_errors <<  [view_cast.errors.full_messages]
  #   end
  # end

