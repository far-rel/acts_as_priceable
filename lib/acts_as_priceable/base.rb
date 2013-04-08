require 'bigdecimal'
require 'bigdecimal/util'

module ActsAsPriceable
  module Base

    def self.included(klass)
      klass.class_eval do
        extend ClassMethods
      end
    end

    module ClassMethods
      def has_price(name = :price, options = {})
        scale = options[:scale] || 2
        without_validations = options[:without_validations] || false
        serialized = options[:serialized]

        ActsAsPriceable::Schema::COLUMNS.each do |column_name, column_type|
          raise AttributeError, "#{name}_#{column_name} is not defined" if columns_hash["#{name}_#{column_name}"].nil?
          raise AttributeError, "#{name}_#{column_name} has wrong column type (is #{columns_hash["#{name}_#{column_name}"].type}) should be #{column_type}" if columns_hash["#{name}_#{column_name}"].type != column_type
        end if serialized.nil?

        gross = "#{name}_gross"
        net = "#{name}_net"
        tax_value = "#{name}_tax_value"
        tax = "#{name}_tax"
        mode = "#{name}_mode"

        send :define_method, "get_#{name}_attribute" do |attribute|
          if serialized.nil?
            self[attribute.to_sym].to_i
          else
            self.send(serialized)[attribute.to_s].to_i
          end
        end

        send :define_method, "set_#{name}_attribute" do |attribute, value|
          if serialized.nil?
            self[attribute.to_sym] = value
          else
            self.send(serialized)[attribute.to_s] = value
          end
        end

        send :define_method, gross do
          BigDecimal.new(self.send("get_#{name}_attribute", gross)) / BigDecimal.new(10**scale.to_i)
        end

        send :define_method, "#{gross}=" do |value|
          self.send "set_#{name}_attribute", gross, (value.to_s.gsub(',', '.').to_d * (10**scale)).to_i
        end

        send :define_method, net do
          BigDecimal.new(self.send("get_#{name}_attribute", net)) / BigDecimal.new(10**scale.to_i)
        end

        send :define_method, "#{net}=" do |value|
          self.send("set_#{name}_attribute", net, (value.to_s.gsub(',', '.').to_d * (10**scale)).to_i)
        end

        send :define_method, tax do
          self.send "get_#{name}_attribute", tax
        end

        send :define_method, "#{tax}=" do |value|
          self.send "set_#{name}_attribute", tax, value
        end

        send :define_method, tax_value do
          send(gross) - send(net)
        end

        send :attr_accessor, mode.to_sym
        send :attr_accessor, name

        send :define_method, "update_#{name}" do
          if self.send(mode).to_s == 'net'
            self.send "#{net}=", self.send(name)
            self.send "#{gross}=", self.send(net) * ((BigDecimal.new(self.send(tax)) / 100) + 1)
          else
            self.send "#{gross}=", self.send(name)
            self.send "#{net}=", self.send(gross) / ((BigDecimal.new(self.send(tax)) / 100) + 1)
          end
        end

        send :before_validation do
          if self.send(name) && self.send(mode)
            self.send "update_#{name}"
          end
        end

        unless without_validations
          send :validates, gross.to_sym, numericality: {greater_than_or_equal_to: 0}
          send :validates, net.to_sym, numericality: {greater_than_or_equal_to: 0}
          send :validates, tax.to_sym, numericality: {greater_than_or_equal_to: 0}
        end

      end

    end

    class AttributeError < StandardError; end

  end
end