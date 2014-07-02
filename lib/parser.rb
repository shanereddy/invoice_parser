require 'ostruct'

class Parser
  def initialize(args)
    @raw = args[:raw]
  end

  def mobile_numbers
    numbers ||= set_mobile_numbers
  end

  def bill number
    monthly = monthly_charges(number)
    usage   = usage_charges(number)
    merged_bill = monthly.concat(usage)

    merged_bill.map! { |line| filter(line) }
  end

  def capture_block array, start_pattern, end_pattern
    captured_lines = []

    capture_flag = false
    array.each do |line|
      capture_flag = true if line =~ /#{start_pattern}/
      captured_lines << line if capture_flag
      return captured_lines if (line =~ /#{end_pattern}/ && capture_flag)
    end

    captured_lines
  end

  def monthly_charges number
    raise NotImplementedError
  end

  def usage_charges number
    raise NotImplementedError
  end

  def invoice_date
    raise NotImplementedError
  end

  def tariff_model number
    raise NotImplementedError
  end
end

class AutoPageParser < Parser
  def raw_mobile_number_data number
    capture_block(@raw, "Mobile number: #{number}", "Subtotal")
  end

  def monthly_charges number
    capture_block(raw_mobile_number_data(number), "Monthly charges", "Usage charges")
  end

  def usage_charges number
    capture_block(raw_mobile_number_data(number), "Usage charges", "Subtotal")
  end

  def invoice_date
    date ||= @raw.each { |line| return $1 if line =~ /Invoice date.*(\d+\/\d+\/\d+)/ }
  end

  def tariff_model number
    raw_mobile_number_data(number).each { |line| return translate_tariff_model($1) if line =~ /Tariff Model: (.*?)$/ }
  end

  def set_mobile_numbers
    numbers = []
    @raw.each do |line| 
      numbers << $1 if line =~ /Mobile number: (\d+)/
    end

    numbers
  end

  def filter line
    if line =~ /(.*?) (\d+\.\d+)/
      translated_item = translate_description($1)
      translated_item.strip!
      return nil if remove_item_from_bill?(translated_item)

      return OpenStruct.new(key: translated_item, value: $2)
    else
      nil
    end
  end

  private
    def translate_description description
      description.gsub(/ R$/,'')
    end

    def translate_tariff_model string
      string.gsub(/\r/,'')
    end

    def remove_item_from_bill? description
      return true if description == "R"
      return true if description == "Subtotal"
      return true if description == ""

      return true if description =~ /Account no/i
      return true if description =~/Account Number/i
      return true if description =~/^[\W+\d+]+$/

      false
    end
end
