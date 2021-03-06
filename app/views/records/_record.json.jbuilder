json.extract! record, :id, :status, :begin_at, :approver_id, :end_at, :address, :tel, :cause, :agent, :agent_office, :agent_office_tel, :agent_mobile, :back_at, :unit_opinion, :leader_opinion,:remark, :back_lat, :back_lon, :travel, :created_at, :updated_at
json.status_value Record.statuses[record.status]
json.user do
    json.partial! 'users/user', user: record.user
end if record.user
json.logs record.record_logs do |log|
    json.partial! 'record_logs/record_log', record_log: log
end
json.url record_url(record, format: :json)
