class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.datetime :created_at, null: false
      t.string :title, limit: 64
      t.string :content, null: false, limit: 255
      t.integer :content_type, null: false, limit: 2, default: 0
      t.integer :user_id, null: false
      t.integer :category_id
      t.integer :parent_entry_id

    end

    add_index :entries, :category_id
    add_index :entries, :parent_entry_id
    add_index :entries, :user_id

    add_foreign_key :entries, :users, on_delete: :cascade

    add_foreign_key :entries, :entries, column: :parent_entry_id, on_delete: :nullify
  end
end
