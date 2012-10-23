require "acts_as_priceable/version"
require "acts_as_priceable/schema"
require "acts_as_priceable/base"
require "active_record"


ActiveRecord::Base.send :include, ActsAsPriceable::Base
