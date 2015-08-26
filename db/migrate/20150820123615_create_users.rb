class CreateUsers < ActiveRecord::Migration
  def change
  	# Use id instead of user_id because I don't have the time nor will to fight rails and it's desire to have id as the primary key.
    create_table :users do |t|
    	t.string :auth_provider, null: false
    	t.string :auth_uid, null: false

    	t.string :display_name, null: false, limit: 30
    	t.string :username, null: false, limit: 20

    	t.boolean :is_admin, null: false, default: false
    	t.boolean :is_banned, null: false, default: false

    	t.string :session_key
    end

    add_index :users, [:auth_provider, :auth_uid], unique: true
    add_index :users, :username, unique: true
    add_index :users, :session_key, unique: true
  end
end
