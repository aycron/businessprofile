class BlogCategory < ActiveRecord::Base
  has_many :blog_posts, :order => "date DESC", :dependent => :destroy
  acts_as_list
  validates_presence_of :name
  
  def to_param
#    "#{self.id}-#{self.name.to_seo}"
    "#{self.id}"
  end
  
end
