class Blog::BlogPostCommentsController < AycronCmsController
  unloadable
  before_filter :authenticate, :except => [:blog_comments_show, :blog_comment_add]
  layout nil
  
  active_scaffold :blog_post_comment do |config|
    config.label = "Blog Post Comment"
    config.list.label = "Blog Post Comments"
    config.list.columns = [:date, :name, :email, :validated, :blog_post_comment_text ]
    config.create.columns = [:name, :date, :email, :validated, :blog_post_comment_text,:url ]
    config.update.columns =   [:name,:date, :email, :validated, :blog_post_comment_text, :url ]
    config.show.columns =  [:date, :name, :email, :validated, :blog_post_comment_text, :url]
    config.list.sorting = {:date => :desc}
    config.columns[:blog_post_comment_text].form_ui = :fckeditor    
    
  end
  
  #ajax call to show blog comments
  def blog_comments_show
    puts "Inside Blog Comments Show"
    @blogCategories =  BlogCategory.find(:all, :order => 'position')
    @blogPostYear = BlogPost.getPostsYears()    
    @newcomment = BlogPostComment.new
    @blogPost = BlogPost.find_by_id(params[:blog_post_id].to_i)
    @selectedCategory = @blogPost.blog_category    
    @blogPost.view_counter = @blogPost.view_counter + 1
    @blogPost.save
  end

  #adds a comment to a given post
  def blog_comment_add
        
    @error_messages = []

    if not simple_captcha_valid?  
        @error_messages << "Invalid captcha"
    end
  
    new_comment = BlogPostComment.new
    new_comment.blog_post_comment_text = params[:blog_post_comment_text]
    new_comment.name = params[:comment_name]    
    new_comment.email = params[:comment_email]
    new_comment.url = params[:comment_url]    
    new_comment.blog_post_id = params[:comment_blog_post]
    new_comment.validated = false
    new_comment.date = Date.today
    if @error_messages.empty? and new_comment.save
      respond_to do |format|
        format.html { redirect_to :controller=> 'blog', :action => 'blog' }
        format.js {
          render :update do |page|
            page.redirect_to :controller=> 'blog', :action => 'blog'
          end
        }
      end
      
    else
#      @page = Page.find(:first, :conditions => ['page_name = ?', "blog"])      
      @blogCategories =  BlogCategory.find(:all, :order => 'position')
      @blogPostYear = BlogPost.getPostsYears()    
      @newcomment = new_comment
      @blogPost = BlogPost.find(new_comment.blog_post_id)
      @selectedCategory = @blogPost.blog_category    
      for  error in new_comment.errors.full_messages
        @error_messages << error
      end      
      respond_to do |format|
        format.js {
          render :update do |page|
            page.replace_html "blog_comments_form", :partial => "new_blog_post_form"
          end          
        }
      end
    end  
  end 
  
end
