class FeedsController < ActionController::Base
  layout nil

  def blog_rss_feed
    @blog_posts = BlogPost.find(:all, :order => 'date DESC', :limit => 10)
    #render_without_layout    @headers["Content-Type"] = "application/xml; charset=utf-8"
  end 

end
