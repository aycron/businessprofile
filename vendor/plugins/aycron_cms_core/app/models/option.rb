class Option < ActiveRecord::Base
  validates_uniqueness_of :key
  
  # Gets the value of a key
  def Option.getValue(key)
    option = Option.find(:first, :conditions => ["options.key = ?", key])
    if option.nil?
      logger.fatal "KEY #{key} NOT FOUND ON OPTIONS TABLE."
      raise ArgumentError, "KEY #{key} NOT FOUND ON OPTIONS TABLE."
    else
      return option.value
    end
  end
  
  def to_label
    "option: #{key} (#{description})"
  end
end
