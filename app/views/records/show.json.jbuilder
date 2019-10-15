json.partial! "records/record", record: @record
json.logs(@record.record_logs) do |log|
  json.partial! 'record_logs/record_log', record_log: log
end