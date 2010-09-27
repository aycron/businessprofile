class Options < ActiveRecord::Migration
  def self.up
  
    create_table :options do |t|
      t.string "key", :null => false
      t.string "value", :limit => 8000
      t.string "option_type", :limit => 20
      t.text "description"
      t.timestamps
    end

    Option.new (
    :key => "MAIL_DELIVERY_METHOD",
    :value => ":smtp_tls",
    :description => "Email delivery method for sending the mails (:smtp_tls, :smtp, :sendmail).",
    :option_type => "STRING"
    ).save!
    
    Option.new (
    :key => "MAIL_FROM",
    :value => "mail.sender@aycron.com",
    :description => "From value for the mail sending.",
    :option_type => "STRING"
    ).save!
    
    Option.new (
    :key => "SMTP_ADDRESS",
    :value => "smtp.gmail.com",
    :description => "Email account information for sending the mails.",
    :option_type => "STRING"
    ).save!
    
    Option.new (
    :key => "SMTP_PORT",
    :value => "587",
    :description => "Email account information for sending the mails.",
    :option_type => "STRING"
    ).save!
    
    Option.new (
    :key => "SMTP_DOMAIN",
    :value => "",
    :description => "Email account information for sending the mails.",
    :option_type => "STRING"
    ).save!
    
    Option.new (
    :key => "SMTP_USER_NAME",
    :value => "mail.sender@aycron.com",
    :description => "Email account information for sending the mails.",
    :option_type => "STRING"
    ).save!
    
    Option.new (
    :key => "SMTP_PASSWORD",
    :value => "m41l.s3nd3r",
    :description => "Email account information for sending the mails.",
    :option_type => "PASSWORD"
    ).save!
    
    Option.new (
    :key => "SMTP_AUTHENTICATION",
    :value => ":plain",
    :description => "Email account information for sending the mails.",
    :option_type => "STRING"
    ).save!
  
  end

  def self.down
    drop_table :options
  end
end
