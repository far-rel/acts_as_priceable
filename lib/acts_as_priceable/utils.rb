module ActsAsPriceable
  module Utils
    def to_gross(value, tax)
      value * BigDecimal.new(100 + tax) / BigDecimal.new(100)
    end

    def to_net(value, tax)
      value / BigDecimal.new(100 + tax) * BigDecimal.new(100)
    end

    def to_bigdecimal(value, scale)
      BigDecimal.new(value, scale + 1)
    end

    def int_to_bigdecimal(value, scale)
      BigDecimal.new(value) / BigDecimal.new(10**scale)
    end

    def bigdecimal_to_int(value, scale)
      (value * 10**scale).to_i
    end

  end
end