json.extract! department, :id, :parent_id, :name, :master_id, :category, :created_at, :updated_at
json.master do
  json.extract! department.master, :id, :realname
end if department.master
json.url department_url(department, format: :json)
