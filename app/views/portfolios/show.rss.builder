xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "#{@portfolio.title}"
    xml.link @portfolio_path
    @portfolio.entries.reorder('created_at desc').includes(:column).each do |entry|
      return if entry.column.show == false
      xml.item do
        xml.title entry.title
        xml.description entry.summary
        xml.pubDate entry.created_at.to_s(:rfc822)
        xml.link portfolio_entry_url(@portfolio, entry)
        xml.guid portfolio_entry_url(@portfolio, entry)
      end
    end
  end
end