class Tag < ActiveRecord::Base
  has_and_belongs_to_many :entries, :join_table => :entries_tags
  belongs_to :portfolio
  validates :name, presence: true, length: { in: 1..150 }
  validates :portfolio, presence: true
  validates :text_color, presence: true
  validates :background_color, presence: true
  validates_format_of :background_color, :with => /\A#(([0-9a-fA-F]{2}){3}|([0-9a-fA-F]){3})\Z/i
  validates_format_of :text_color, :with => /\A#(([0-9a-fA-F]{2}){3}|([0-9a-fA-F]){3})\Z/i
end
