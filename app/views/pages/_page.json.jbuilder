json.extract! page, :id, :site_id, :account_id, :folder_id, :headline, :meta_description, :publised_date, :is_published, :summary, :alignment, :isinteractive, :genre, :sub_genre, :series, :by_line, :cover_image_id, :created_at, :updated_at
json.url page_url(page, format: :json)
