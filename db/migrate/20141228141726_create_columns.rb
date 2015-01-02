class CreateColumns < ActiveRecord::Migration
  def change
    create_table :columns do |t|
      t.string :name
      t.string :background_color
      t.string :text_color
      t.integer :entries_per_page
      t.integer :position
      t.boolean :show

      t.timestamps null: true
    end
  end
end
