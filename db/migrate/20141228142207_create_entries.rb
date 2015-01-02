class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.references :column, index: true
      t.string :title
      t.text :summary
      t.text :content
      t.boolean :sticky
      t.boolean :title_link
      t.boolean :external_title_link
      t.string :external_url
      t.string :slug

      t.timestamps null: false
    end
    add_foreign_key :entries, :columns
  end
end
