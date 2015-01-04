class Column < ActiveRecord::Base
  belongs_to :portfolio
  has_many :entries, dependent: :destroy
  has_many :tags, through: :portfolio
  validates_presence_of :portfolio
  validates :position, :inclusion => { :in => 0..4 }
  validates_presence_of :background_color
  validates_presence_of :text_color
  validates :entries_per_page, :inclusion => { :in => 1..100, :message => "Entries per page should be in between 1 and 100." }
  validates_length_of :name, :maximum => 1000, :allow_blank => true
  validates_format_of :background_color, :with => /\A#(([0-9a-fA-F]{2}){3}|([0-9a-fA-F]){3})\Z/i
  validates_format_of :text_color, :with => /\A#(([0-9a-fA-F]{2}){3}|([0-9a-fA-F]){3})\Z/i

  scope :positioned, -> { order(position: :asc) }
  scope :showing, ->(show) { where(show: true)}

  def get_entries(tag=false)
  	if tag
  	  self.entries.includes(:tags).joins(:tags).where(:tags => { :name => tag })
  	else
  	  self.entries.includes(:tags)
  	end
  end

  def change_column_positions(old_position, new_position, column_to_replace)
    if !(column_to_replace)
      errors.add :base, "Tried to move to position that doesn't exist"
      return
    elsif column_to_replace.position == 0 || old_position == 0
      errors.add :base, "Cannot change position of first column."
      return
    elsif new_position.to_i > 4
      errors.add :base, "You tried to move your column to a position that doesn't exist."
      return
    else
      if self.update(position: new_position) && column_to_replace.update(position: old_position)
        true
      else
         errors.add :base, "Failed to update column position."
      end
    end
  end

  def toggle_show
    if self.show? && !(self.first_column?)
      self.show = false
      self.save
    elsif !(self.show?) && !(self.first_column?)
      self.show = true
      self.save
    end
  end

  def first_column?
    self == self.portfolio.columns.first
  end

end
