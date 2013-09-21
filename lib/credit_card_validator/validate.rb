module CreditCardValidator
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
      valid_number
      find_card_type
    end

    def errors
      @errors
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
        @errors <<  Error.new({ :type => 'name', :message => 'Invalid type'})
        return "Unknown"
      end
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
        @errors << Error.new({ :type => 'number', :message => 'Invalid card number'})
      end
    end

  end
end
