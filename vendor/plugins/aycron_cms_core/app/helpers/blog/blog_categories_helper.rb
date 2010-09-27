module Blog::BlogCategoriesHelper
  
   def posts_column(record)
    string = ""
    for post in record.blog_posts 
      string = string + " " + post.title + ","
    end
    if not string.empty?
      string.chop
    else
      "[NONE]"
    end
  end
end
