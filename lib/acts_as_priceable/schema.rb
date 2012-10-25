module ActsAsPriceable

  module Schema
    COLUMNS = {
        net: :integer,
        gross: :integer,
        tax: :integer
    }

    def self.included(base)
      ActiveRecord::ConnectionAdapters::Table.send :include, TableDefinition
      ActiveRecord::ConnectionAdapters::TableDefinition.send :include, TableDefinition
      ActiveRecord::ConnectionAdapters::AbstractAdapter.send :include, Statements

      if defined?(ActiveRecord::Migration::CommandRecorder) # Rails 3.1+
        ActiveRecord::Migration::CommandRecorder.send :include, CommandRecorder
      end
    end

    module Statements

      def add_price(table_name, *price_names)
        raise ArgumentError, "Please specify price name in your add_price call in your migration." if price_names.empty?

        price_names.each do |price_name|
          COLUMNS.each do |column_name, column_type|
            add_column(table_name, "#{price_name}_#{column_name}", column_type)
          end
        end
      end

      def remove_price(table_name, *price_names)
        raise ArgumentError, "Please specify price name in your remove_price call in your migration." if price_names.empty?

        price_names.each do |price_name|
          COLUMNS.each do |column_name, _|
            remove_column(table_name, "#{price_name}_#{column_name}")
          end
        end
      end

    end

    module TableDefinition

      def price(*price_names)
        price_names.each do |price_name|
          COLUMNS.each do |column_name, column_type|
            column("#{price_name}_#{column_name}", column_type)
          end
        end
      end

    end

    module CommandRecorder

      def add_price(*args)
        record(:add_price, args)
      end

      private

      def invert_add_price(args)
        [:remove_price, args]
      end

    end

  end

end