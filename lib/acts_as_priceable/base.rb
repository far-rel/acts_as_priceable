require 'bigdecimal'

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
        setup_accessors
      end

      def setup_accessors
        @price_fields ||= [{
            name: :price,
            options: DEFAULTS
        }]
        @price_fields.each do |config|
          setup_field config[:name], config[:options]
        end
      end

      def setup_field(field, options)
        setup_net field, options
        setup_gross field, options
      end

      def setup_gross(field, options)
        self.send :attr_accessor, :"#{field}_gross"
        self.send :define_method, "#{field}_gross" do
          value = (options[:db_type] == :integer ? int_to_bigdecimal(self[field], options[:scale]) : float_to_bigdecimal(self[field]))
          if options[:db_store] == :gross
            value
          else
            to_gross value, options[:tax]
          end
        end
        self.send :define_method, "#{field}_gross=" do |value|

        end
      end

      def setup_net(field, options)
        self.send :attr_accessor, :"#{field}_net"
        self.send :define_method, "#{field}_net" do

        end
        self.send :define_method, "#{field}_net=" do |value|

        end
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