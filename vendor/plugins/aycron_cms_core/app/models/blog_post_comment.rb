class BlogPostComment < ActiveRecord::Base
  apply_simple_captcha
  belongs_to :blog_post
  validates_inclusion_of :validated, :in => [true, false]
  validates_presence_of :name
  validates_presence_of :blog_post_comment_text
#  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
#                      :message => 'must be valid'
  
  def to_label
    "post comment by : #{name}: #{email}"
  end
  
  def blog_category
    blog_post.blog_category.name
  end
  
 
end
