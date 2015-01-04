json.title @portfolio.title

json.columns @portfolio.columns.positioned.includes(:entries) do |column|
  next if column.show == false
  json.column_name column.name
  json.entries column.entries.stickies_first.each do |entry|
    json.entry_title entry.title
    json.entry_created_at entry.created_at.to_s
    json.entry_summary entry.summary
    json.entry_content entry.content
  end
end