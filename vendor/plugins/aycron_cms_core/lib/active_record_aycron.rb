module ActiveRecord
  class Base
    class << self
      def human_name(options = {})
        defaults = self_and_descendants_from_active_record.map do |klass|
          :"#{klass.name.underscore}"
        end
        defaults << self.name.underscore.humanize
        I18n.translate(defaults.shift, {:scope => [:activerecord, :models], :count => 1, :default => defaults}.merge(options))
      end
    end
  end
end