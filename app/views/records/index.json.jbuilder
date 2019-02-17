json.partial! 'common/page', resources: @records
json.items @records do |record|
    json.partial! 'records/record', record: record
end