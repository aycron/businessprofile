class RoleController < ActiveRecord::Base
  belongs_to :role
  validates_presence_of :role, :controller
  
  def to_label
    "#{role} - #{controller}"
  end
end
