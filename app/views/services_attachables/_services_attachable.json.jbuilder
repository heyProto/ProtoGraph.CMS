json.extract! services_attachable, :id, :account_id, :attachable_id, :attachable_type, :genre, :file_url, :original_file_name, :file_type, :s3_bucket, :created_by, :updated_by, :created_at, :updated_at
json.url services_attachable_url(services_attachable, format: :json)
