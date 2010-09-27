class Pages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string "name", :null => false
      t.string "title"
      t.text "content"
      t.integer "position"
      t.timestamps
    end
    
    Page.new (
    :name => "nosotros",
    :title => "Nosotros",
    :position => 1
    ).save!
    
    Page.new (
    :name => "ayuda",
    :title => "Ayuda",
    :position => 2
    ).save!
    
    Page.new (
    :name => "contactanos",
    :title => "Contáctanos",
    :position => 3
    ).save!
    
    Page.new (
    :name => "anunciate",
    :title => "Anúnciate con Nosotros",
    :position => 4
    ).save!
    
  end

  def self.down
    drop_table :pages
  end
end
