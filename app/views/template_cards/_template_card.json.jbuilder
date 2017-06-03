json.extract! template_card, :id, :account_id, :template_datum_id, :name, :description, :slug, :version, :is_current_version, :status, :publish_count, :created_by, :updated_by, :created_at, :updated_at
json.url template_card_url(template_card, format: :json)
