class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :entry_id, null: false
      t.string :tag_title, null: false, limit: 64
    end

    add_index :tags, :entry_id # For getting all tags for an entry.
    add_index :tags, :tag_title # For getting all entries for a tag.
    add_index :tags, [:entry_id, :tag_title], unique: true

    add_foreign_key :tags, :entries, on_delete: :cascade
  end
end
