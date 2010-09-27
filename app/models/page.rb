class Page < ActiveRecord::Base
  has_attached_file :photo, :styles => { :small => "285x250>", :thumb => "50x50"}
end
