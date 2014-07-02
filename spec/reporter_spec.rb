require "invoice"
require "parser"
require "reporter"

describe Reporter do
  before do
    @invoice  = Invoice::Text.new(file: "spec/input/original.txt", parser: AutoPageParser).serialize
    @parser   = AutoPageParser.new(raw: @invoice)
    @reporter = Reporter.new(invoice_date: @parser.invoice_date, 
                           number: "0732635332", 
                           tariff_model: @parser.tariff_model("0732635332"), 
                           raw_bill: @parser.bill("0732635332")
                          )
  end

  describe "methods" do
    before do
      @result = @reporter.construct
    end

    describe ".construct" do
      it "should return the formatted date" do
        expect(@result[:invoice_date]).to eq "2014-04-01"
      end   

      it "should return the formatted number" do
        expect(@result[:number]).to eq "27732635332"
      end   

      it "should return the tariff model instead of Telephony" do
        found_flag = false
        @result[:bill].each do |hash|
          found_flag = true if hash[:description] == "Vodacom Smart XL"
        end

        expect(found_flag).to be_truthy
      end   
    end
  end

end
