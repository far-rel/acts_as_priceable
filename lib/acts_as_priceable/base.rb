require 'bigdecimal'

module ActsAsPriceable
  module Base

    def self.included(klass)
      klass.class_eval do
        extend Config
      end
    end

    module Config

      PRICEABLE_DEFAULTS = {
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
            options: PRICEABLE_DEFAULTS
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
          value = (options[:db_type] == :integer ?
              int_to_bigdecimal(self.send(field).to_i, options[:scale]) :
              to_bigdecimal(self.send(field).to_f, options[:scale]))
          if options[:db_store] == :gross
            value
          else
            to_gross value, options[:tax]
          end
        end
        self.send :define_method, "#{field}_gross=" do |value|
          tmp = to_bigdecimal value, options[:scale]
          if options[:db_store] == :net
            tmp = to_net(tmp, options[:tax])
          end
          tmp = options[:db_type] == :integer ?
              bigdecimal_to_int(tmp, options[:scale]) : tmp.to_f
          self.send("#{field}=".to_sym, tmp)
        end
      end

      def setup_net(field, options)
        self.send :attr_accessor, :"#{field}_net"
        self.send :define_method, "#{field}_net" do
          value = (options[:db_type] == :integer ?
              int_to_bigdecimal(self.send(field).to_i, options[:scale]) :
              to_bigdecimal(self.send(field).to_f, options[:scale]))
          if options[:db_store] == :net
            value
          else
            to_net value, options[:tax]
          end
        end
        self.send :define_method, "#{field}_net=" do |value|
          tmp = to_bigdecimal value, options[:scale]
          if options[:db_store] == :gross
            tmp = to_gross(tmp, options[:tax])
          end
          tmp = options[:db_type] == :integer ?
              bigdecimal_to_int(tmp, options[:scale]) : tmp.to_f
          self.send("#{field}=".to_sym, tmp)
        end
      end

      def append_price(name, options = {})
        @price_fields ||= []
        @price_fields << {
            name: name,
            options: PRICEABLE_DEFAULTS.merge(options)
        }
      end

    end
  end
end