class GalleryImage < ActiveRecord::Base
  belongs_to :profile
  acts_as_list :scope=>:profile, :order=>"position ASC"
  
  has_attached_file :image,
    :styles => {
      :mini => "55x30!",
      :thumb=> "164x126#",
      :main  => "558x306!"
    
  }
    
  def to_label
    image_file_name
  end
end
