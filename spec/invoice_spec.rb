require 'invoice'
require 'parser'

describe Invoice::Text do

  describe "new" do
    it "should take a file argument and parser class" do
      expect{Invoice::Text.new(file: "spec/input/original.txt", parser: AutoPageParser)}.not_to raise_error
    end

    it "should raise an error for no file argument" do
      expect{Invoice::Text.new}.to raise_error(ArgumentError)
    end
  end

  describe "methods" do
    before do
      @invoice = Invoice::Text.new(file: "spec/input/original.txt", parser: AutoPageParser)
    end

    describe ".serialize" do
      it "should construct an output array" do
        expect(@invoice.serialize).to be_kind_of(Array)
      end
    end

    describe ".numbers" do
      it "should return the mobile numbers for the invoice" do
        expect(@invoice.numbers).to eq ["0732635332", "0828741815"]
      end
    end

    describe ".parse" do
      before do
        @result = @invoice.parse("0732635332")
      end
      it "should return the expected invoice_date" do
        expect(@result[:invoice_date]).to eq "2014-04-01"
      end

      it "should return the expected mobile number" do
        expect(@result[:number]).to eq "27732635332"
      end

      it "should return the expected bill object" do
        expect(@result[:bill]).to be_kind_of(Array)
      end
    end

  end
end

describe Invoice::Pdf do

  describe "new" do
    it "should take a file argument and parser class" do
      expect{Invoice::Pdf.new(file: "spec/input/Invoice.pdf", parser: AutoPageParser)}.not_to raise_error
    end

    it "should raise an error for no file argument" do
      expect{Invoice::Pdf.new}.to raise_error(ArgumentError)
    end
  end

  describe "methods" do
    before do
      @invoice = Invoice::Pdf.new(file: "spec/input/Invoice.pdf", parser: AutoPageParser)
    end

    describe ".serialize" do
      it "should construct an output array" do
        expect(@invoice.serialize).to be_kind_of(Array)
      end
    end

    describe ".numbers" do
      it "should return the mobile numbers for the invoice" do
        expect(@invoice.numbers).to eq ["0732635332", "0828741815"]
      end
    end

    describe ".parse" do
      before do
        @result = @invoice.parse("0732635332")
      end
      it "should return the expected invoice_date" do
        expect(@result[:invoice_date]).to eq "2014-04-01"
      end

      it "should return the expected mobile number" do
        expect(@result[:number]).to eq "27732635332"
      end

      it "should return the expected bill object" do
        expect(@result[:bill]).to be_kind_of(Array)
      end
    end

  end
end
