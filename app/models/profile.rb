class Profile < ActiveRecord::Base
  has_many :gallery_images, :dependent => :destroy, :order => "position ASC"
  has_one :marker, :dependent => :destroy
  has_many :profile_tabs, :dependent => :destroy, :order => "position ASC"
  has_many :users
  
  validates_format_of :contact_email, :with => EMAIL_SHORT
  validates_format_of :second_contact_email, :with => EMAIL_SHORT
  
  has_attached_file :logo,
      :styles =>{
      :logo  => "74x74!"}
  
  has_attached_file :image,
    :styles =>{
     :box=> "355x312!" }
  
  def to_label
    title
  end
  
  def before_save
    self.url = self.title.to_seo
  end
end
