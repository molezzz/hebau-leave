json.extract! department, :id, :parent_id, :name, :category, :created_at, :updated_at
json.url department_url(department, format: :json)
