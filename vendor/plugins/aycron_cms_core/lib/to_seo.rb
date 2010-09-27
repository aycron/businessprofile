class String
  
  # Grande Lucas por el aporte!
  def to_seo 
    seo_url_format = self.gsub("&", "and")
    seo_url_format.parameterize
  end

end