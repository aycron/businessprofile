class AddSecondContactEmailToProfile < ActiveRecord::Migration
  def self.up
     add_column :profiles, :second_contact_email, :string
  end

  def self.down
    remove_column :profiles, :second_contact_email
  end
end
