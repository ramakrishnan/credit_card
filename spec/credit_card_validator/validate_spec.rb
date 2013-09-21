require 'spec_helper'
module CreditCardValidator

  describe Validate do
    context 'Starting up' do
      it 'should ignore white spaces and hyphen from card number' do
        cc = Validate.new({ :number => '411 122-236'})
        cc.send('card_number').length.should eq(9)
      end
    end

    context 'Check for card type' do
      it 'Say AMEX when number begins with 34 or 37 and length equals to 15' do
        cc = Validate.new({ :number => '341111111111111'})
        cc.type.should eq('AMEX')
      end
      it 'Say Discover when number begins with 6011 and length equals to 16' do
        cc = Validate.new({ :number => '6011111111111111'})
        cc.type.should eq('Discover')
      end
      it 'Say MasterCard when number begins with 51 or 55 and length equals to 16' do
        cc = Validate.new({ :number => '5111111111111111'})
        cc.type.should eq('MasterCard')
      end
      it 'Say Visa when number begins with 4 and length equals to 16' do
        cc = Validate.new({ :number => '4111111111111111'})
        cc.type.should eq('Visa')
      end
      it 'Say Visa when number begins with 4 and length equals to 13' do
        cc = Validate.new({ :number => '4111111111111'})
        cc.type.should eq('Visa')
      end
    end

    describe 'Validate number by performing Luhn algorithm' do
      context 'For a valid VISA card' do
        let(:cc) { Validate.new({ :number => '4408 0412 3456 7893'}) }
        before :each do
          cc.valid?
        end
        it 'Should have no errors' do
          cc.errors.should be_empty
        end
        it 'Should say card type as VISA' do
          cc.type.should eq('Visa')
        end
      end

      context 'For an Unknown card number' do
        let(:cc) {Validate.new({ :number => '9111111111111111'})}
        before :each do
          cc.valid?
        end
        it 'Should say card type as Unknown' do
          cc.type.should eq('Unknown')
        end
        it 'Should have error with invalud card type' do
          cc.errors.map { |error| error.message }.should include('Invalid type')
        end
        it 'Should have error with invalud card number' do
          cc.errors.map { |error| error.message }.should include('Invalid card number')
        end
      end

      context 'For an invalid card number' do
        let(:cc) {Validate.new({ :number => '4417 1234 5678 9112'})}
        before :each do
          cc.valid?
        end
        it 'Should have error with invalud type' do
          cc.errors.map { |error| error.message }.should include('Invalid card number')
        end
      end
    end

  end
end
