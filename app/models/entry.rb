class Entry < ActiveRecord::Base
  extend FriendlyId

  friendly_id :title, :use => [:scoped, :slugged, :finders], :scope => [:portfolio]

  belongs_to :column
  belongs_to :portfolio
  has_and_belongs_to_many :tags, :join_table => :entries_tags
  validates_presence_of :column
  validates_presence_of :portfolio
  validates_presence_of :title
  validates :title, length: {minimum: 1, maximum: 255}
  validates :summary, length: {maximum: 100000}, allow_blank: true
  validates :content, length: {maximum: 100000}, allow_blank: true

  before_validation :format_url, :if => lambda {|entry| entry.external_url_changed?  }

  scope :stickies_first, -> { order(sticky: :desc, created_at: :desc) }


  def format_url
    url = self.external_url
    self.external_url = "http://#{url}" unless url=~/^https?:\/\//
  end


end
