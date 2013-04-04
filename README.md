# ActsAsPriceable

This gem is extension for ActiveRecord which provides mechanism for handling prices.

## Installation

Add this line to your application's Gemfile:

    gem 'acts_as_priceable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acts_as_priceable

## Migrations

You can add all columns which are needed by this gem using provided migrations
```ruby

  def change
    create_table :products do |t|
      t.price :price
      # This creates 3 column
      # t.integer :price_gross
      # t.integer :price_net
      # t.integer :price_tax
    end
  end

```

```ruby

  def change
    add_price :products, :price
  end

```

```ruby

  def change
    remove_price :products, :price
  end

```

## Usage

Basics
------

```ruby
class Product < ActiveRecord::Base
  has_price :price
end
```

This provides accessors which wraps created database columns. `price_gross` and `price_net` converts integer columns into BigDecimal with some scale (default scale is 2).
Ex. if `price_gross` in database is `1000`, accessor will return `10.00` as BigDecimal.

`price_tax` is percentage VAT tax added to net price.
`price_tax_value` is value of tax.

Instead of setting `price_net` and `price_gross` separately you can use `price` and `price_mode` accessors.

```ruby
p = Product.new
p.price_tax = 20
p.price = '10.00'
p.price_mode = 'net'
p.save
p.price_net # 10.00
p.price_gross # 12.00
```

Recalculating price takes place in before_validation. You can recalculate it manually by calling `update_price` method.

NOTE: `price_net`, `price_gross`, etc. are made from `has_price` method first argument. You can have different name for price accessor or even two or more prices

```ruby
class Product < ActiveRecord::Base
  has_price :price
  has_price :promotion
end
```

This defines `price_net` etc. as well as `promotion_net` ...

Validations
-----------

On default `price_tax`, `price_net` and `price_gross` can't be lower than 0. You can turn off validation by setting `without_validation` parameter to true in options.

Configuration
-------------
```ruby
class Product < ActiveRecord::Base
  has_price :price, scale: 4,
                    without_validation: true
end
```




## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
