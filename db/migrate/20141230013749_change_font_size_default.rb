class ChangeFontSizeDefault < ActiveRecord::Migration
  def up
    change_column :portfolios, :font_size, :integer, :default => 12
  end

  def down
    change_column :portfolios, :font_size, :boolean
  end
end
