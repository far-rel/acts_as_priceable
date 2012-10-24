require 'rspec'
require 'acts_as_priceable'
require 'yaml'


def create_tables
  ActiveRecord::Base.connection.create_table :dummies, force: true do |table|
    table.column :price_gross, :integer
    table.column :price_net, :integer
    table.column :price_tax, :integer
  end
end

RSpec.configure do |config|
  ActiveRecord::Base.establish_connection YAML.load_file("#{File.dirname __FILE__}/database.yml")['test']
  create_tables
  require 'models/dummy'
  config.color_enabled = true
  #config.formatter = 'documentation'
end
