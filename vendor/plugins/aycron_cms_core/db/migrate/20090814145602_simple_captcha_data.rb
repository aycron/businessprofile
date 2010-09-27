class SimpleCaptchaData < ActiveRecord::Migration
  def self.up
    create_table :simple_captcha_data do |t|
      t.string :key, :limit => 40
      t.string :value, :limit => 6
      t.timestamps
    end
  end

  def self.down
    drop_table :simple_captcha_data
  end
end
