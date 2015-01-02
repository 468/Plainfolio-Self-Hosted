json.title @portfolio.title

json.columns @portfolio.columns.includes(:entries) do |column|
  next if column.show == false
  json.column_name column.name
  json.entries column.entries.each do |entry|
    json.entry_title entry.title
    json.entry_created_at entry.created_at.to_s
    json.entry_summary entry.summary
    json.entry_content entry.content
  end
end