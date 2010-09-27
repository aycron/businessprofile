class OptionsController < AycronCmsController
  unloadable

  active_scaffold :option do |config|
    config.create.multipart = true
    config.update.multipart = true
    config.actions.exclude :create, :delete
    config.list.columns = [:key, :value, :description]
    config.show.columns = [:key, :value, :description, :created_at, :updated_at]
    config.update.columns = [:value]
    config.list.sorting = {:key => 'ASC'}
    config.columns[:value].form_ui = :fckeditor   #only for the RICH_TEXT option type
  end
 
  def after_create_save(record)
    restartOptionsServerConfiguration
  end

  def after_update_save(record)
    restartOptionsServerConfiguration
  end

end
