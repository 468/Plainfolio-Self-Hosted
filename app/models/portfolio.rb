class Portfolio < ActiveRecord::Base
  require 'csv'
  belongs_to :admin
  validates_presence_of :admin
  has_many :columns, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :entries, through: :columns
  accepts_nested_attributes_for :columns, :entries
  validates :title, presence: true, length: { in: 1..255 }
  validates :font_size, :inclusion => 8..24
  validates :url, presence: true

  # password protection validations & callbacks
  has_secure_password validations: false
  validates :password, length: {in: 1..40}, :if => lambda {|portfolio| portfolio.passworded_changed? && portfolio.passworded }
  after_save :reset_password_digest, :if => lambda {|portfolio| portfolio.passworded_changed? && portfolio.passworded == false }

  # create columns/dummy entries upon initial Portfolio creation
  after_create :set_defaults

  # records visit count with Impressionable gem
  is_impressionable

  # -- default setup start --

  def set_defaults
    self.update(font: 'helvetica', font_size: 12, passworded: false, rss_enabled: true, pdf_enabled: true)
    create_columns
    create_example_tag
    example_tag_id = self.tags.first.id
    create_example_entries(example_tag_id)
  end

  def create_columns
  	self.columns.create(name: 'About', show: true, entries_per_page: 10, background_color: '#303030', text_color: '#fff', position: 0 )
  	self.columns.create(name: 'A', show: true, entries_per_page: 10, background_color: '#fff', text_color: '#111', position: 1 )
    self.columns.create(name: 'B', show: true, entries_per_page: 10, background_color: '#fff', text_color: '#111', position: 2)
  	self.columns.create(name: 'C', show: true, entries_per_page: 10, background_color: '#fff', text_color: '#111', position: 3)
  	self.columns.create(name: 'D', show: true, entries_per_page: 10, background_color: '#fff', text_color: '#111', position: 4, show:false )
  end

  def create_example_tag
   self.tags.create(name: 'Sample Tag', text_color: '#ffffff', background_color: '#FF4A4A')
  end

  def create_example_entries(example_tag_id)
    self.columns.positioned.first.entries.create(title: "Logging In", portfolio: self, summary: "In future you can access this admin area by logging in at #{self.url}/login.")
    self.columns.positioned.first.entries.create(title: "Hello", portfolio: self, summary: "This column is your 'main' column -- it is shown on all pages and isn't affected by tag sorting. A good place to put contact info, an 'about me' paragraph, links to other websites/social media accounts, etc.")
    self.columns.positioned.second.entries.create(title: "Example Entry II",portfolio: self, summary: "<iframe width='560' height='315' src='//www.youtube.com/embed/HelnM33rZ3w' frameborder='0' allowfullscreen></iframe><br>Video embed example. You can embed videos by clicking the <img src='http://i.imgur.com/HYlR2tC.png' alt='Edit Code Icon' /> button on the text editor and pasting your embed code.", content: "Extra interior page content here.", title_link: true, :tag_ids => [example_tag_id])
    self.columns.positioned.second.entries.create(title: "Example entry", portfolio: self, summary: "This is an example entry tagged with an example tag.", :tag_ids => [example_tag_id])
  end

  # -- default setup end --

  #  conversion to csv file
  def as_csv
    CSV.generate do |csv|
      csv << [self.title]
      self.columns.positioned.each do |column|
        csv << [column.name]
        column.entries.stickies_first.each do |entry|
          csv << [nil, entry.title, entry.summary, entry.content]
        end
      end
    end
  end

  private
    # to wipe password after password protection is disabled
    def reset_password_digest
      self.update_columns(password_digest: nil)
    end


end
