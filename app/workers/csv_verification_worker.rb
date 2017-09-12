class CsvVerificationWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => true

  def perform(upload_id)
    @upload = Upload.find(upload_id)
    @upload.update_columns(upload_status: "uploading")
    require 'csv'
    # open3 to capture stderr from jq
    require 'open3'
    # The last jq filter returns an array of json objects
    card_array_filtered = []
    filtering_errors = []
    row_number = 2
    total_rows = 0
    CSV.foreach(@upload.attachment.file.file, headers: true) do |row|
      total_rows += 1
      stdout, stderr, status = Open3.capture3("echo #{row.to_h.to_json.gsub('\n', '\\n').to_json} | jq -f ref/jq_filter/jq_filter_#{@upload.template_card.name}.jq")
      if stdout.present?
        card_array_filtered << stdout
      elsif stderr.present?
        filtering_errors << [row_number, stderr]
      end
      row_number += 1
    end
    @upload.update_columns(total_rows: total_rows)
    @upload.upload_errors = "[]"
    @upload.save!
    @upload.update_columns(filtering_errors: filtering_errors.to_json)
    puts "======== Filtering Errors =======\n#{filtering_errors}"
    i = 2
    rows_uploaded = 0
    card_array_filtered.each do |card_filtered|
      upload_card(@upload.id, i, JSON.parse(card_filtered))
      i += 1
      rows_uploaded += 1
      @upload.update_columns(rows_uploaded: rows_uploaded)
    end
    CsvErrorWorker.perform_async(@upload.id)
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
    puts card_data
    # # converts card_data keys to symbols because of data retrieval in different cards
    # card_data = card_data.symbolize_keys
    params = {toReportViolence: {
                name: "data/copy_paste_from_article/headline",
                seo_blockquote_text: "data/when_and_where_it_occur/approximate_date_of_incident,
                  data/when_and_where_it_occur/area,
                  data/when_and_where_it_occur/district,
                  data/when_and_where_it_occur/state,
                  data/the_incident/describe_the_event,
                  data/the_people_involved/title,
                  data/the_incident/classification,
                  data/the_people_involved/victim_names,
                  data/the_people_involved/victim_social_classification,
                  data/the_people_involved/accused_names,
                  data/the_people_involved/accused_social_classification"},
              toExplain: {
                name: "data/explainer_header",
                seo_blockquote_text: "data/explainer_text"},
              toReportJournalistKilling: {
                name: "data/details_about_journalist/name",
                seo_blockquote_text: "data/when_and_where_it_occur/date,
                  data/when_and_where_it_occur/location,
                  data/when_and_where_it_occur/state,
                  data/details_about_journalist/organisation,
                  data/details_about_journalist/organisation_type,
                  data/when_and_where_it_occur/accused_names,
                  data/details_about_journalist/journalist_body_of_work,
                  data/when_and_where_it_occur/description_of_attack,
                  data/details_about_journalist/beat"},
             }
    name_path = params[@upload.template_card.name.to_sym][:name]
    seo_blockquote_text_path = params[@upload.template_card.name.to_sym][:seo_blockquote_text]

    name = card_data
    name_path.split("/").each do |dir|
      name = name[dir]
    end
    seo_text = ""
    seo_blockquote_text_path.split(",").each do |field|
      seo_blockquote_text = card_data
      field.strip.split("/").each do |dir|
        seo_blockquote_text = seo_blockquote_text[dir]
      end
      seo_text = seo_blockquote_text + "</p>\n<p>" + seo_text
    end

    return name, seo_text
  end
end

