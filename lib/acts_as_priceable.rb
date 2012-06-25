require "acts_as_priceable/version"
require "acts_as_priceable/config"
require "active_record"


ActiveRecord::Base.send :include, ActsAsPriceable::Config
