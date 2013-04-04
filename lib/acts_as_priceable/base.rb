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

        ActsAsPriceable::Schema::COLUMNS.each do |column_name, column_type|
          raise AttributeError, "#{name}_#{column_name} is not defined" if columns_hash["#{name}_#{column_name}"].nil?
          raise AttributeError, "#{name}_#{column_name} has wrong column type (is #{columns_hash["#{name}_#{column_name}"].type}) should be #{column_type}" if columns_hash["#{name}_#{column_name}"].type != column_type
        end

        gross = "#{name}_gross"
        net = "#{name}_net"
        tax_value = "#{name}_tax_value"
        tax = "#{name}_tax"
        mode = "#{name}_mode"

        send :define_method, gross do
          BigDecimal.new(self[gross.to_sym].to_i) / BigDecimal.new(10**scale.to_i)
        end

        send :define_method, "#{gross}=" do |value|
          self[gross.to_sym] = (value.to_s.gsub(',', '.').to_d * (10**scale)).to_i
        end

        send :define_method, net do
          BigDecimal.new(self[net.to_sym].to_i) / BigDecimal.new(10**scale.to_i)
        end

        send :define_method, "#{net}=" do |value|
          self[net.to_sym] = (value.to_s.gsub(',', '.').to_d * (10**scale)).to_i
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