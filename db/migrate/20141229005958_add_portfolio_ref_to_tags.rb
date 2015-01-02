class AddPortfolioRefToTags < ActiveRecord::Migration
  def change
    add_reference :tags, :portfolio, index: true
    add_foreign_key :tags, :portfolios
  end
end
