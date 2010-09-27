class AddContactSubjectToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :contact_me_subject, :string
  end

  def self.down
    remove_column :profiles, :contact_me_subject
  end
end
