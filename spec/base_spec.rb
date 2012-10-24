require 'spec_helper'

describe Dummy do

  describe 'class methods' do
    it 'should have has_price method' do
      Dummy.should respond_to(:has_price)
    end
  end

  describe 'instance' do

    before(:all) do
      Dummy.send :has_price, :price
      @test_value = '10.20'
    end

    describe 'methods' do


      before(:each) do
        @dummy = Dummy.new
      end

      it 'should have price attr_accessor' do
        @dummy.should respond_to(:price)
        @dummy.should respond_to(:price=)
      end

      it 'should have mode attr_accessor' do
        @dummy.should respond_to(:mode)
        @dummy.should respond_to(:mode=)
      end

      it 'should have price_tax_value method' do
        @dummy.should respond_to(:price_tax_value)
      end

      it 'should have update_price method' do
        @dummy.should respond_to(:update_price)
      end

      it 'price_net should be converted to integer' do
        @dummy.price_net = @test_value
        @dummy[:price_net].should be(1020)
      end

      it 'price_net should return correct value' do
        @dummy.price_net = @test_value
        @dummy.price_net.should == BigDecimal.new(@test_value)
      end

      it 'price_gross should be converted to integer' do
        @dummy.price_gross = @test_value
        @dummy[:price_gross].should be(1020)
      end

      it 'price_gross should return correct value' do
        @dummy.price_gross = @test_value
        @dummy.price_gross.should == BigDecimal.new(@test_value)
      end

      it 'calculates price gross from price_net' do
        @dummy.price = '10.00'
        @dummy.price_tax = 23
        @dummy.mode = 'net'
        @dummy.update_price
        @dummy.price_net.should == BigDecimal.new('10.00')
        @dummy.price_gross.should == BigDecimal.new('12.30')
      end

      it 'calculates price net from price gross' do
        @dummy.price = '12.30'
        @dummy.price_tax = 23
        @dummy.mode = 'gross'
        @dummy.update_price
        @dummy.price_net.should == BigDecimal.new('10.00')
        @dummy.price_gross.should == BigDecimal.new('12.30')
      end

      it 'calculates tax value properly' do
        @dummy.price = '10.00'
        @dummy.price_tax = 23
        @dummy.mode = 'net'
        @dummy.update_price
        @dummy.price_tax_value.should == BigDecimal.new('2.30')
      end

    end

    describe 'validations' do

      before(:each) do
        @dummy = Dummy.new price: '10.00', mode: 'net', price_tax: 23
        @dummy.update_price
      end

      it 'correct should be valid' do
        @dummy.valid?.should be(true)
      end

      it "price_net can't be negative" do
        @dummy.price_net = -1
        puts @dummy.price_net >= 0
        puts @dummy[:price_net]
        puts @dummy.valid?
        puts @dummy.errors.keys
        puts Dummy.validators_on(:price_net)
        @dummy.valid?.should be(false)
      end

      it "price_gross can't be negative" do
        @dummy.price_gross = -1
        @dummy.valid?.should be(false)
      end

      it "price_tax can't be negative" do
        @dummy.price_tax = -1
        @dummy.valid?.should be(false)
      end
    end
  end

end