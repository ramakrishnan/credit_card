module CreditCard
	class Validate
		attr_accessor :number
		attr_reader :type

		def initialize(options)
			@errors = []
			@number = options[:number]
		end

		def type
			@type ||= find_card_type
		end

		def valid?
			validate
			errors.empty?
		end

		def validate
			@errors = []
			find_card_type
			valid_number
		end

		def valid_number
			count = 0
			card_number.split('').reverse.each_with_index do |number, index|
				number = number.to_i
				new_num =  index % 2 == 0 ? number : 2*number
				new_num = new_num >= 10 ?  1 + ( new_num - 10 ) : new_num
				count += new_num
			end
			is_valid = count % 10 == 0
			unless is_valid
				@errors << Error.new({ :type => 'number', :error => 'Invalid card number'})
			end
		end

		def card_number
			@card_number ||= number.gsub(' ','').gsub('-','')
		end

		protected

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
				@errors <<	Error.new({ :type => 'name', :error => 'Invalid type'})
				return "Unknown"
			end
		end

	end
end
