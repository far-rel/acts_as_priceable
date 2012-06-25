module ActsAsPriceable
  module Base

    def self.included(klass)
      klass.class_eval do
        extend Config
      end
    end

    module Config

      DEFAULTS = {
          tax: 23,
          db_type: :integer,
          db_store: :net,
          scale: 2
      }

      def acts_as_priceable(&block)
        yield self if block_given?
      end

      def append_price(name, options = {})
        @price_fields ||= []
        @price_fields << {
            name: name,
            options: DEFAULTS.merge(options)
        }
      end

    end
  end
end