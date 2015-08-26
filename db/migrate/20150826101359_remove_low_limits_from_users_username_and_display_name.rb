class RemoveLowLimitsFromUsersUsernameAndDisplayName < ActiveRecord::Migration
  def change
  	change_column :users, :username, :string, :limit => nil
  	change_column :users, :display_name, :string, :limit => nil
  end
end
