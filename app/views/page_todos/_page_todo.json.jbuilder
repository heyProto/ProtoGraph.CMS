json.extract! page_todo, :id, :page_id, :user_id, :template_card_id, :task, :is_completed, :sort_order, :created_by, :updated_by, :created_at, :updated_at
json.url page_todo_url(page_todo, format: :json)
