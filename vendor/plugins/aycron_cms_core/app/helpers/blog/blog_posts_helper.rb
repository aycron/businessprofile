module Blog::BlogPostsHelper
  
  def blog_post_text_show_column(record)
    record.blog_post_text
  end
  
  def blog_category_column(record)
    record.blog_category.name
  end
  
  def blog_post_text_form_column(record, input_name)
    fckeditor_textarea( :record, "blog_post_text", :ajax => true, :toolbarSet => FCKEDITOR_BLOG_TOOLBAR_SET,
    :width => FCKEDITOR_WIDTH, :height => FCKEDITOR_HEIGHT )
  end

end
