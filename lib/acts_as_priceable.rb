require "acts_as_priceable/version"
require "acts_as_priceable/base"
require "acts_as_priceable/utils"
require "active_record"


ActiveRecord::Base.send :include, ActsAsPriceable::Base
ActiveRecord::Base.send :include, ActsAsPriceable::Utils
