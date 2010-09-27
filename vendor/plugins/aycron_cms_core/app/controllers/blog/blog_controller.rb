class Blog::BlogController < ApplicationController
  unloadable
  layout :set_layout
  #shows the blog
  def blog
    #@page = Page.find(:first, :conditions => ['page_name = ?', "blog"])
    @blogCategories =  BlogCategory.find(:all, :order => 'position')
    @blogPosts = BlogPost.find(:all, :order => 'date DESC')
    @blogPostYear = BlogPost.getPostsYears()
    blog_calculate_pagination()
  end
  
  #Search in the blog_post name and title the words entered in the search form
  def blog_search
    #@page = Page.find(:first, :conditions => ['page_name = ?', "blog"])    
    @results = []
    
    if params[:search].length > 30 then params[:search] = params[:search][0,30] end
    blogPosts = BlogPost.find(:all, :conditions => ["blog_post_text like ? or title like ? ", "%#{params[:search]}%", "%#{params[:search]}%"])
    @results.concat(blogPosts)
    @words = params[:search].split(" ")
    for word in @words
      if word.length > 15 then word = word[0,15] end
      blogPosts = BlogPost.find(:all, :conditions => ["blog_post_text like ? or title like ?", "%#{word}%", "%#{word}%"])
      @results.concat(blogPosts)
    end
    @results = @results.uniq  
    
    #@page = Page.find(:first, :conditions => ['page_name = ?', "blog"])
    @blogCategories =  BlogCategory.find(:all, :order => 'position')
    @blogPosts = @results
    @blogPostYear = BlogPost.getPostsYears()
  end
  
  #shows the blogs of a given year. the parameter that receives is the year
  def blog_by_year
    @selectedYear = params[:year]
    #@page = Page.find(:first, :conditions => ['page_name = ?', "blog"])
    @blogCategories =  BlogCategory.find(:all, :order => 'position')
    @blogPosts = BlogPost.find(:all, :conditions => ['year(date) = ?',  @selectedYear], :order => 'date DESC')
    @blogPostYear = BlogPost.getPostsYears()
    blog_calculate_pagination()    
    render :action => 'blog'
  end
  
  #shows the  blogs of a given category. The parameter that receives is the category_id
  def blog_by_category
    @selectedCategory = BlogCategory.find(params[:category])
    #@page = Page.find(:first, :conditions => ['page_name = ?', "blog"])
    @blogCategories =  BlogCategory.find(:all, :order => 'position')
    @blogPosts = @selectedCategory.blog_posts
    @blogPostYear = BlogPost.getPostsYears()
    blog_calculate_pagination()    
    render :action => 'blog'
  end
  
  #shows the permalink for a given blog post. Receives as parameter the blog_post id
  def blog_permalink
    #@page = Page.find(:first, :conditions => ['page_name = ?', "blog"])
    @blogCategories =  BlogCategory.find(:all, :order => 'position')
    blogPostSelected = BlogPost.find(params[:permalink])    
    @selectedCategory = blogPostSelected.blog_category    
    @blogPosts = BlogPost.find(:all, :conditions => ['id= ?',   blogPostSelected.id])
    @blogPostYear = BlogPost.getPostsYears()
    blog_calculate_pagination()     
    render :action => 'blog'
  end
  
  #pagination for blog
  def blog_calculate_pagination()
    
    @last_page = calculate_blog_last_page(@blogPosts.length)
    if params[:page_number].nil?
      @actual_page = 1
      offset = 0
    else
      @actual_page = params[:page_number].to_i
      offset = (@actual_page -1) * RESULTS_PER_PAGE    
    end
    
    if @blogPosts.length >= offset + RESULTS_PER_PAGE
      @blogPosts = @blogPosts [offset..(offset+RESULTS_PER_PAGE - 1)]
    else 
      @blogPosts = @blogPosts [offset..@blogPosts.length]
    end
  end 
  
  #calculate last page for the blog
  def calculate_blog_last_page(result_length)
    #calculate last page      
    @last_page = result_length / RESULTS_PER_PAGE
    if (result_length.to_f % RESULTS_PER_PAGE) != 0
      @last_page+=1
    end
    return @last_page
  end
  
  #ajax action to calculate rating
  def rate_post()
    @blogPost = BlogPost.find(params[:blog_post_id])
    @blogPost.total_rating = @blogPost.total_rating + params[:rate].to_i 
    @blogPost.total_votes = @blogPost.total_votes + 1    
    @blogPost.avg_rating = @blogPost.calculate_avg_rating()
    @blogPost.save
    respond_to_js do
      render :update do |page|
        page.replace_html "post_rating_#{@blogPost.id}", RatingsRenderer.new(self, @blogPost.id).render(@blogPost.avg_rating)
      end
    end
  end
  
  private
  
  def respond_to_js
    respond_to do |format|
      format.js do
        yield
      end
    end
  end
  
  
  def set_layout
    
    case action_name
      when 'blog' then BLOG_LAYOUT
      when 'blog_search' then BLOG_LAYOUT
      when 'blog_by_year' then BLOG_LAYOUT
      when 'blog_by_category' then BLOG_LAYOUT
      when 'blog_permalink' then BLOG_LAYOUT
    else nil
    end    
    
  end
  
end