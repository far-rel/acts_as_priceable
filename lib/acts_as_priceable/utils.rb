module ActsAsPriceable
  module Utils
    def to_gross(value, tax)
      value * BigDecimal.new(100 + tax) / BigDecimal.new(100)
    end

    def to_net(value, tax)
      value / BigDecimal.new(100 + tax) * BigDecimal.new(100)
    end

    def float_to_bigdecimal(value)
      BigDecimal.new(value)
    end

    def int_to_bigdecimal(value, scale)
      BigDecimal.new(value) / BigDecimal.new(10**scale)
    end

  end
end