json.extract! record, :id, :status, :begin_at, :end_at, :address, :tel, :cause, :agent, :agent_office, :agent_office_tel, :agent_mobile, :back_at, :unit_opinion, :leader_opinion, :created_at, :updated_at
json.user do
    json.partial! 'users/user', user: record.user
end
json.url record_url(record, format: :json)
