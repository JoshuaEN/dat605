class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :entry_id, null: false
      t.integer :user_id, null: false
    end

    add_index :favorites, :entry_id
    add_index :favorites, :user_id
    add_index :favorites, [:entry_id, :user_id], unique: true

    add_foreign_key :favorites, :users, on_delete: :cascade
    add_foreign_key :favorites, :entries, on_delete: :cascade
  end
end
