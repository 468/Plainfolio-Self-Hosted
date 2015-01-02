class AddPortfolioRefToColumns < ActiveRecord::Migration
  def change
    add_reference :columns, :portfolio, index: true
    add_foreign_key :columns, :portfolios
  end
end
