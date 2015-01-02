class CreateJoinTableEntryTag < ActiveRecord::Migration
  def change
    create_table :entries_tags, id: false do |t|
      t.references :entry, :tag
  	end
  	add_index :entries_tags, [:entry_id, :tag_id], :unique => true
  end
end
