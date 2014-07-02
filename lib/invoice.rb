module Invoice
  require_relative "reporter"
  attr_reader :serialized, :parser

  def initialize(args)
    @file       = args[:file]
    @serialized = serialize
    @parser     = args[:parser].new(raw: @serialized)
  end

  def serialize
    @output ||= read_file
  end

  def numbers
    @parser.mobile_numbers
  end

  def parse number
    bill = Reporter.new(invoice_date: @parser.invoice_date, 
                        number: number, 
                        tariff_model: @parser.tariff_model(number), 
                        raw_bill: @parser.bill(number)
                       ).construct
  end
end

class Invoice::Text
  include Invoice

  def read_file
    output = []
    File.readlines(@file, :encoding => 'ISO-8859-1').each do |line|
      output << line
    end

    output
  end

end

class Invoice::Pdf
  include Invoice

  def read_file
    require 'pdf/reader'
    
    output = []
    File.open(@file,'rb') do |io|
      reader = PDF::Reader.new(io)
      reader.pages.each do |page|
        output.concat(page.text.split("\n"))
      end
    end

    convert_whitespaces_to_single_space(output)
  end

  private
    def convert_whitespaces_to_single_space output
      output.map { |item| item.gsub(/\s+/,' ') }
    end
end
