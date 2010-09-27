class Users < ActiveRecord::Migration
  def self.up

    create_table :users do |t|
      t.string "username", :null => false
      t.string "first_name"
      t.string "last_name"
      t.string "hashed_password", :null => false
      t.integer "role_id"
      t.string "email", :null => false
      t.string "password_reset_code"
      t.timestamps
    end
    add_index :users, :username
    add_index :users, :email

    create_table :roles do |t|
      t.string "name", :null => false
      t.boolean "is_super_admin", :null => false, :default => false
      t.timestamps
    end

    create_table :role_controllers do |t|
      t.integer "role_id", :null => false
      t.string "controller", :null => false
      t.boolean "can_view", :null => false, :default => false
      t.boolean "can_edit", :null => false, :default => false
      t.timestamps
    end
    add_index :role_controllers, [:role_id, :controller]


    (super_admin = Role.new(:name => 'super admin', :is_super_admin => true)).save!

    User.new (
      :username => 'aycron',
      :hashed_password =>'aycr0n',
      :role_id => super_admin.id,
      :email => 'info@aycron.com'
    ).save!

  end

  def self.down
    drop_table :users
    remove_index :users, :username
    remove_index :users, :email
    drop_table :roles
    drop_table :role_controllers
    remove_index :role_controllers, [:role_id, :controller]
  end

end
