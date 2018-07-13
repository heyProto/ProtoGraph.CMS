json.extract! template_app, :id, :name, :genre, :pitch, :description, :is_public, :installs, :views, :created_by, :updated_by, :change_log, :created_at, :updated_at
json.url template_app_url(template_app, format: :json)
