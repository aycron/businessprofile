class Attachment < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
  acts_as_list :scope => 'attachable_id = #{attachable_id.to_i} AND attachable_id IS NOT NULL'
  default_scope :order => "position ASC"
end
