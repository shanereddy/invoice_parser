require 'date'

class Reporter
  def initialize args
    @invoice_date = args[:invoice_date]
    @number       = args[:number]
    @tariff_model = args[:tariff_model]
    @raw_bill     = args[:raw_bill]
  end

  def construct
    output = {}

    output[:invoice_date] = convert_to_required_date_format(@invoice_date)
    output[:number]       = convert_mobile_number_to_international_format(@number)
    output[:bill]         = construct_bill

    output
  end

  def construct_bill
    bill = []
    @raw_bill.each do |item|
      next if item.nil?

      bill << { description: substitute_description(item.key), amount: item.value.to_f }
    end

    bill
  end

  private
    def convert_mobile_number_to_international_format number
      number = number.gsub(/^0/,'27')
      number = number.gsub(/\+27/,'27')
    end

    def convert_to_required_date_format date
      Date.parse(date).strftime('%Y-%m-%d')
    end

    def substitute_description description
      if (description == "Telephony")
        return @tariff_model
      else
        return description
      end
    end
end
