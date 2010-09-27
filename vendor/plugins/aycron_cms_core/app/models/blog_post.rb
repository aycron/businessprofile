class BlogPost < ActiveRecord::Base
  has_many :blog_post_comments, :order => "created_at DESC", :dependent => :destroy
  belongs_to :blog_category
  validates_presence_of :blog_category
  validates_presence_of :title
  validates_presence_of :blog_post_text
  
  def BlogPost.getPostsYears()
    blogPosts = BlogPost.find(:all, :order => 'date DESC')
    return blogPosts.collect {|post| post.date.year}.uniq
  end
  
  def validated_comments()
    
    results = []
    for comment in blog_post_comments
      if comment.validated
        puts ("COMMENTS:" + comment.id.to_s)
        results << comment
      end
    end
    return results
    
  end
  
  def validated_comments_length()
    return  validated_comments().length
  end
  
  def calculate_avg_rating()
    if total_votes !=0
      return (total_rating / total_votes)
    else
      return 0
    end  
  end

  def to_param
#    "#{self.id}-#{self.title.to_seo}"
    "#{self.id}"
  end
  
end