require 'rspec'
require 'acts_as_priceable'
require 'yaml'


def create_tables
  #ActiveRecord::Base.connection.execute "CREATE EXTENSION hstore;"

  ActiveRecord::Base.connection.create_table :dummies, force: true do |table|
    table.column :price_gross, :integer
    table.column :price_net, :integer
    table.column :price_tax, :integer
  end

  ActiveRecord::Base.connection.create_table :dummy_serializes, force: true do |table|
    table.column :hstore_data, :hstore
    table.column :hash_data, :text
  end
end

RSpec.configure do |config|
  ActiveRecord::Base.establish_connection YAML.load_file("#{File.dirname __FILE__}/database.yml")['test']
  create_tables
  #require 'active_support'
  require 'activerecord-postgres-hstore'
  require 'models/dummy'
  require 'models/dummy_serialize'
  config.color_enabled = true
  #config.formatter = 'documentation'
end
