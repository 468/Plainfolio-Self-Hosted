xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "#{@portfolio.title}"
    xml.link @portfolio_path
    @portfolio.entries.order('created_at desc').includes(:column).each do |entry|
      if !(entry.column.on_show?)
        next
      else
        xml.item do
          xml.title entry.title
          xml.description entry.summary
          xml.pubDate entry.created_at.to_s(:rfc822)
          xml.link entry_url(entry)
          xml.guid entry_url(entry)
        end
      end
    end
  end
end