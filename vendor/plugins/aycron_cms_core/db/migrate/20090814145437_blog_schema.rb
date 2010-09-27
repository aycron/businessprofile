class BlogSchema < ActiveRecord::Migration

  def self.up

    if BLOG_ACTIVE
      
      create_table :blog_categories do |t|
        t.string "name", :null => false
        t.integer "position"
        t.timestamps
      end
      
      create_table :blog_posts do |t|
        t.integer "blog_category_id", :null => false
        t.string "title", :null => false
        t.datetime "date"
        t.text "blog_post_text"
        t.string "permalink"
        t.float "total_rating", :default => 0
        t.float "avg_rating", :default => 0      
        t.integer "total_votes",:default => 0
        t.integer "view_counter",:default => 0      
        t.timestamps
      end
      
      create_table :blog_post_comments do |t|
        t.integer "blog_post_id", :null => false
        t.datetime "date"     
        t.text "blog_post_comment_text", :null => false            
        t.string "name", :null => false            
        t.string "email"
        t.string "url"      
        t.boolean "validated", :null => false
        t.timestamps
      end
  
      add_index("blog_posts", "blog_category_id")
      add_index("blog_posts", "date")    
      add_index("blog_post_comments", "blog_post_id")    
  
      # Add blog role and permissions
      Role.new(:name => "blog editor").save!    
    
    end

  end
  
  def self.down

    if BLOG_ACTIVE

      remove_index("blog_posts", "blog_category_id")
      remove_index("blog_posts", "date")    
      remove_index("blog_post_comments", "blog_post_id")  
      
      drop_table :blog_categories
      drop_table :blog_posts
      drop_table :blog_post_comments
  
      role = Role.find_by_name("blog editor")
      role.destroy unless role.nil?

    end
    
  end
  
end
