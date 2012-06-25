module ActsAsPriceable
  module Config

    #class_attribute :priceable_fields

    DEFAULTS = {
        tax: 23,
        db_type: :integer,
        db_store: :net,
        scale: 2
    }

    def acts_as_priceable(&block)
      yield self if block_given?
    end

    def append_price(name, options = {})
      priceable_fields ||= []
      priceable_fields << {
          name: name,
          options: DEFAULTS.merge(options)
      }
    end

  end
end