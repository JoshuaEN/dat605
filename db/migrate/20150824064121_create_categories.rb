class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :category_title, null: false, limit: 64
    end

    add_index :categories, :category_title, unique: true # Dupe titles makes no sense in this context.

    # Categories doesn't exist before now.
    add_foreign_key :entries, :categories, on_delete: :nullify
  end
end
