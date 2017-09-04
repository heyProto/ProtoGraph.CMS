class CsvVerificationWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => true

  def perform(upload_id)
    @upload = Upload.find(upload_id)
    require 'csv'
    # open3 to capture stderr from jq
    require 'open3'
    # The last jq filter returns an array of json objects
    card_array_filtered = []
    filtering_errors = []
    row_number = 2
    CSV.foreach(@upload.attachment.file.file, headers: true) do |row|
      stdout, stderr, status = Open3.capture3("echo #{row.to_h.to_json.to_json} | jq -f ref/jq_filter/jq_filter_#{@upload.template_card.name}.jq")
      if stdout.present?
        card_array_filtered << stdout
      elsif stderr.present?
        filtering_errors << [row_number, stderr]
      end
      row_number += 1
    end
    @upload.upload_errors = "[]"
    @upload.filtering_errors = filtering_errors.to_json.to_s
    @upload.save
    i = 2
    card_array_filtered.each do |card_filtered|
      upload_card(@upload.id, i, JSON.parse(card_filtered))
      i += 1
    end
    puts filtering_errors
  end

  def upload_card(upload_id, row_number, card_data)
    @upload = Upload.find(upload_id)
    payload = {}
    params = all_params(card_data)
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
        upload_error = [row_number, r['errorMessage']]
      end
    else
      upload_error =  [row_number, view_cast.errors.full_messages]
    end
    if upload_error.nil?
      upload_error = []
    end
    upload_errors = JSON.parse(@upload.upload_errors)
    upload_errors << upload_error
    @upload.upload_errors = upload_errors.to_json.to_s
    @upload.save
  end

  def all_params(card_data)
    name, seo_blockquote_text = get_view_cast_details(card_data)
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

  def get_view_cast_details(card_data)
    params = {toReportViolence: {
                name: "data/the_people_involved/title",
                seo_blockquote_text: "data/"},
              toExplain: {
                name: "data/explainer_header",
                seo_blockquote_text: "data/explainer_text"
              }
             }
    name_path = params[@upload.template_card.name.to_sym][:name]
    seo_blockquote_text_path = params[@upload.template_card.name.to_sym][:seo_blockquote_text]

    name = card_data
    name_path.split("/").each do |dir|
      name = name[dir]
    end

    seo_blockquote_text = card_data
    seo_blockquote_text_path.split("/").each do |dir|
      seo_blockquote_text = seo_blockquote_text[dir]
    end

    return name, seo_blockquote_text
  end
end

