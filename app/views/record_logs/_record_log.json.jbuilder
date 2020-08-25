json.extract! record_log, :id, :kind, :remark, :created_at
json.user do
  json.extract! record_log.user, :id, :realname, :mobile
end if record_log.user