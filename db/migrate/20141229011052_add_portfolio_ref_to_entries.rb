class AddPortfolioRefToEntries < ActiveRecord::Migration
  def change
    add_reference :entries, :portfolio, index: true
    add_foreign_key :entries, :portfolios
  end
end
