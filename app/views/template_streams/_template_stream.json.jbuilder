json.extract! template_stream, :id, :account_id, :name, :description, :slug, :version, :is_current_version, :status, :publish_count, :created_by, :updated_by, :created_at, :updated_at
json.url template_stream_url(template_stream, format: :json)
