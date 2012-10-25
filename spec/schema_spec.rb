require 'spec_helper'

describe ActsAsPriceable::Schema do

  before(:all) do
    ActiveRecord::Migration.verbose = false
    @migration = Class.new(ActiveRecord::Migration) do
      def change
        create_table :migration_tests, force: true do |t|
          t.price :price
        end
      end
    end

    @add_migration = Class.new(ActiveRecord::Migration) do
      def change
        add_price :migration_tests, :second_price
      end
    end
    @migration.new.migrate(:up)
    @model = Class.new(ActiveRecord::Base) do
      self.table_name = :migration_tests
    end
  end

  after(:all) do
    @migration.new.migrate(:down)
  end

  it 'creates table with price_net, price_gross and price_tax with proper types' do
    columns = @model.columns.map{ |column| [column.name, column.type] }

    columns.should include(['price_net', :integer])
    columns.should include(['price_tax', :integer])
    columns.should include(['price_gross', :integer])
  end

  it 'adds proper fields and removes it' do
    @add_migration.new.migrate(:up)
    @model.reset_column_information
    columns = @model.columns.map{ |column| [column.name, column.type] }

    columns.should include(['second_price_net', :integer])
    columns.should include(['second_price_tax', :integer])
    columns.should include(['second_price_gross', :integer])

    @add_migration.new.migrate(:down)
    @model.reset_column_information
    columns = @model.columns.map{ |column| [column.name, column.type] }

    columns.should_not include(['second_price_net', :integer])
    columns.should_not include(['second_price_tax', :integer])
    columns.should_not include(['second_price_gross', :integer])
  end


end