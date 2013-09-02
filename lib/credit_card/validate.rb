module CreditCard
	class Validate
		attr_accessor :number
		attr_reader :type

		def initialize(options)
			@number = options[:number]
		end

		def type
			@type ||= find_card_type
		end

		def valid?
			validate
			errors.empty
		end

		def validate
			@errors = []
			find_card_type
			valid_number
		end

		def errors
			@errors
		end

		def valid_number
			count = 0
			card_number.split('').reverse.each_with_index do |index, number|
				number = number.to_i
				count += index % 2 == 0 ? 2*number : number
			end
			count % 10 == 0
		end

		protected

		def card_number
			@card_number ||= number.gsub(' ','').gsub('-','')
		end

		def find_card_type
			if card_number.length == 15 and ['34', '37'].include? card_number[0..1]
				return "AMEX"
			elsif card_number.length == 16 and card_number[0..3] == '6011'
				return "Discover"
			elsif card_number.length == 16 and ['51', '55'].include? card_number[0..1]
				return "MasterCard"
			elsif (card_number.length == 16 || card_number.length == 13) and card_number[0] == '4'
				return "Visa"
			else

			end
		end

	end
end
