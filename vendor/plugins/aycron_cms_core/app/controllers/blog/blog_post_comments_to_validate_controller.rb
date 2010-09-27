class Blog::BlogPostCommentsToValidateController < AycronCmsController
  unloadable
  helper "Blog::BlogPostComments"
  
  active_scaffold :blog_post_comment do |config|
    config.label = "Blog Post Comment"
    config.list.label = "Blog Post Comments"
    config.columns << :post_blog_category    
    config.list.columns = [:post_blog_category, :blog_post, :created_at, :name, :email, :validated, :blog_post_comment_text ]
    config.actions.exclude :create
    config.update.columns =   [:name, :email, :blog_post_comment_text ]
    config.show.columns =  [:post_blog_category, :blog_post, :created_at, :name, :email, :validated, :blog_post_comment_text ]
    config.list.label = "Comments To Validate"
    config.list.sorting = [{:created_at => :desc}]
    config.list.per_page = 20
    config.columns[:blog_post_comment_text].form_ui = :fckeditor    
    config.columns[:post_blog_category].label = "Blog Category"
    config.columns[:post_blog_category].sort_by :method => "blog_category"
    config.columns[:blog_post].includes = [:blog_post]
    config.columns[:blog_post].sort_by :sql => "blog_posts.title"
    
 config.action_links.add 'validate', :label => 'Validate', :type => :record, :position => false, :method => 'put'
  end
  
  def conditions_for_collection
    ['validated = ?', :false]
  end

  def validate
    postComment= BlogPostComment.find(params[:id])
    postComment.validated=true
    postComment.save
    do_list
    render :action => 'validate'

end

end
