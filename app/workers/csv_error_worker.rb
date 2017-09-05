class CsvErrorWorker
  include Sidekiq::Worker
  sidekiq_options :backtrace => true

  def perform(upload_id)
    require 'csv'
    @upload = Upload.find(upload_id)
    file_path = @upload.attachment.file.file.split("/").slice(0..-2).join("/")
    errors = []
    # Filtering errors and upload errors are saved in different
    # column because they are processed at different times
    JSON.parse(@upload.filtering_errors).each do |a|
      if a.present?
        errors << a
      end
    end
    JSON.parse(@upload.upload_errors).each do |a|
      if a.present?
        errors << a
      end
    end
    # Gives all cumulative errors
    errors = errors.sort
    all_rows = []
    # Reads all the original rows from csv
    CSV.read(@upload.attachment.file.file, headers: true).each do |row|
      all_rows << row.to_h
    end
    errored_rows = []
    errors.each do |e|
      # Gets the row from csv with row number as error
      errored_row = all_rows[e[0] - 2]
      er_with_error = errored_row.to_a << ["errors", e[1]]
      errored_rows << er_with_error.to_h
    end
    if errored_rows.present?
      CSV.open("#{file_path}/errored_file.csv", "wb", write_headers: true, headers: errored_rows.first.keys) do |csv|
        errored_rows.each do |e|
          csv << e.values
        end
      end
    end
  end
end
