json.extract! template_datum, :id, :account_id, :name, :description, :slug, :version, :is_current_version, :status, :api_key, :publish_count, :created_by, :updated_by, :created_at, :updated_at
json.url template_datum_url(template_datum, format: :json)
