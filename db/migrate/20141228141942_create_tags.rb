class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.string :text_color
      t.string :background_color

      t.timestamps null: false
    end
  end
end
