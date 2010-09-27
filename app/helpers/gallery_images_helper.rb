module GalleryImagesHelper
  
  def image_column(record)
    image_tag(record.image.url(:mini))
  end
end