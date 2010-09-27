class Blog::BlogPostsController < AycronCmsController
  unloadable

  active_scaffold :blog_post do |config|
    config.label = "Blog Post" 
    config.list.label = "Blog Posts" 
    config.columns << :blog_category
    config.list.columns = [:blog_category, :date, :title]
    config.create.columns = [:blog_category, :date, :title, :blog_post_text]
    config.update.columns = [:blog_category, :date, :title, :blog_post_text, :total_rating, :total_votes, :view_counter]
    config.show.columns =  [:blog_category, :date,:title, :blog_post_text, :total_rating, :total_votes, :view_counter, :avg_rating]
    config.columns[:blog_post_text].form_ui = :fckeditor
    config.columns[:blog_category].includes = [:blog_category]
    config.columns[:blog_category].sort_by :sql => "blog_categories.name"
    config.columns[:blog_category].clear_link()
    config.columns[:blog_category].form_ui = :select
    config.list.sorting = [{:date => :desc}]
    config.list.per_page = 20
    config.nested.add_link("Comments", [:blog_post_comments])
  end

  def before_update_save(record)
    record.avg_rating = record.calculate_avg_rating()
  end

end
