class GeneratePDF
  require 'nokogiri'
  require 'open-uri'
  require 'openssl'

  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  attr_reader :portfolio

  def initialize(portfolio)
    @portfolio = portfolio
  end

   def generate_pdf
    pdf = Prawn::Document.new
    pdf.text portfolio.title, size: 40, style: :bold
    pdf.text "(view online at #{portfolio.url})", size: 10, inline_format: true
    pdf.move_down 15
    portfolio.columns.positioned.where(show: true).each do |column|
      pdf.text "#{column.name}:", size: 20, style: :bold
      pdf.move_down 15
      column.entries.stickies_first.each do |entry|
        format_for_pdf(entry, pdf)
        pdf.move_down 15
      end
    end
    return pdf
  end

  def format_for_pdf(entry, pdf)
  	sanitize_config = Sanitize::Config.merge(Sanitize::Config::BASIC, :elements => Sanitize::Config::BASIC[:elements] + ['color'], :attributes => { 'a' => ['href', 'title'], 'color' => ['rgb'], 'img'  => ['alt', 'src', 'title']} )
  	summary = entry.summary
  	content = entry.content
    url = entry.portfolio.url
  	summary_pics = get_pics(Nokogiri::HTML(summary) )
  	content_pics = get_pics(Nokogiri::HTML(content) )
  	if entry.external_title_link
  	  pdf.text "<a href='#{entry.external_url}'><u><b>#{entry.title}</b></u></a>" + get_tags_for_pdf(entry), inline_format: true
  	else
  	  pdf.text "<u><b>#{entry.title}</b></u>" + get_tags_for_pdf(entry), inline_format: true
  	end
  	pdf.move_down 15
  	write_to_pdf(split_and_sub(summary, url), pdf, summary_pics, sanitize_config) if summary
  	write_to_pdf(split_and_sub(content, url), pdf, content_pics, sanitize_config) if content
  end

  def get_pics(target)
  	target.css('img').map { |link| link['src'] }
  end

  def get_tags_for_pdf(entry)
  	if entry.tags.count > 0
  	  " (" + entry.tags.map { |tag| tag.name }.join(", ") + ")"
  	else
  	  ""
  	end
  end

  def split_and_sub(target, url)
  	replacements = [ ["<a href=", "<color rgb='0000FF'><a href="], ["</a>", "</a></color>"],["<li>", "\u2022 "], ["</li>", "<br>"], ["<p>", "<br>"], [/<p style=.*>/, "<br>"], ["</p>", "<br>"], ["<ul>", ""], ["</ul>", ""], ["<ol>", ""], ["</ol>", ""], [/<iframe[^>]+>.*?<\/iframe>/, "<color rgb='0000FF'><a href='#{url}'>[Click to view]</a></color>"]]
	  replacements.each {|replacement| target.gsub!(replacement[0], replacement[1])}
  	target.split(/<img[^>]*>/)
  end

  def write_to_pdf(fragments, pdf, pics=[], sanitize_config)

  	fragments.each_with_index do |fragment, index|
  	  pdf.text Sanitize.fragment(fragment, sanitize_config ), inline_format: true
  	  if pics[index]
  	  	begin
  	      pdf.image open(pics[index]), width: 100
  	  	rescue
  	  	end
  	  	pdf.text "<a href='#{pics[index]}'>#{pics[index]}</a>", inline_format: true, style: :italic, :size => 10
  	  end
  	end

    # in case there is image but no text fragments
    if fragments.length == 0 && pics.length > 0
      pics.each_with_index do |pic,index|
        pdf.image open(pics[index]), width: 100
        pdf.text "<a href='#{pics[index]}'>#{pics[index]}</a>", inline_format: true, style: :italic, :size => 10
      end
    end

  end


end