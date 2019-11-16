json.extract! department, :id, :parent_id, :name, :master_id, :category, :created_at, :updated_at
json.url department_url(department, format: :json)
