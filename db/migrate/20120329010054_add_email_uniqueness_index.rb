class AddEmailUniquenessIndex < ActiveRecord::Migration
  def up
  	#add index to users table email column
  	add_index :users, :email, :unique => true
  end

  def down
  	remove_index :users, :email
  end
end
