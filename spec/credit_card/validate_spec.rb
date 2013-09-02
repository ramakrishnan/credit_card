require File.join(File.dirname(__FILE__), "/../spec_helper" )
module CreditCard

	describe Validate do
		context 'Starting up' do
			it 'should consider only numbers' do
				pending "Add validations"
			end

			it 'should ignore white spaces and hyphen from card number' do
				cc = Validate.new({ :number => '411 122-236'})
				cc.card_number.length.should eq(9)
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

		context 'Valid number by performing Luhn algorithm' do
			it 'should split odd and even positions of card number (R to L)' do
				cc = Validate.new({ :number => '4408 0412 3456 7893'})
				cc.valid_number.should eq(true)
				cc.type.should eq('Visa')
			end
		end

	end
end
