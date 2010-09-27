class OptionsSuperController < AycronCmsController
  unloadable
  helper :options

  active_scaffold :option do |config|
    config.columns = [:key, :option_type, :value, :description]
  end

  def after_create_save(record)
    restartOptionsServerConfiguration
  end

  def after_update_save(record)
    restartOptionsServerConfiguration
  end

end
