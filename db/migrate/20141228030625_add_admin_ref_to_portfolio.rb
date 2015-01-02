class AddAdminRefToPortfolio < ActiveRecord::Migration
  def change
    add_reference :portfolios, :admin, index: true
    add_foreign_key :portfolios, :admins
  end
end
