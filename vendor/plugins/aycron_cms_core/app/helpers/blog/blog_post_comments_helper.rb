module Blog::BlogPostCommentsHelper
  
  def post_blog_category_column(record)
    record.blog_post.blog_category.name
  end

  def blog_post_comment_text_column(record)
    record.blog_post_comment_text
  end
  
  def blog_post_comment_text_form_column(record, input_name)
    fckeditor_textarea( :record, "blog_post_comment_text", :ajax => true, :toolbarSet => FCKEDITOR_BLOG_COMMENTS_TOOLBAR_SET,
    :width => FCKEDITOR_WIDTH, :height => FCKEDITOR_HEIGHT )
  end
  
end
