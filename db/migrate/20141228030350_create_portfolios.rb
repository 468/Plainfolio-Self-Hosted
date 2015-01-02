class CreatePortfolios < ActiveRecord::Migration
  def change
    create_table :portfolios do |t|
      t.string :title
      t.string :font
      t.boolean :font_size
      t.boolean :passworded
      t.string :password_digest
      t.boolean :pdf_enabled
      t.boolean :rss_enabled

      t.timestamps null: false
    end
  end
end
