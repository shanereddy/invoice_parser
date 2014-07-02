require "invoice"
require "parser"

describe AutoPageParser do
  describe "Text input" do
    before do
      @invoice = Invoice::Text.new(file: "spec/input/original.txt", parser: AutoPageParser).serialize
      @parser = AutoPageParser.new(raw: @invoice)
    end

    describe ".invoice_date" do
      it "should return the invoice date" do
        expect(@parser.invoice_date).to eq "1/04/2014"
      end
    end

    describe ".mobile_numbers" do
      it "should return the mobile numbers for the invoice" do
        expect(@parser.mobile_numbers).to eq ["0732635332", "0828741815"]
      end
    end

    describe ".tariff_model" do
      let(:numbers) do
        ["0732635332", "0828741815"]
      end
      
      it "should return the tariff model for the mobile number" do
        expect(@parser.tariff_model("0732635332")).to eq "Vodacom Smart XL"
        expect(@parser.tariff_model("0828741815")).to eq "Vodacom 2GB"
      end
    end

    describe ".filter" do
      it "should return the correct 'Phone Insurance'" do
        expect(@parser.filter("Phone Insurance 64.04R\r\n").key).to eq "Phone Insurance"
        expect(@parser.filter("Phone Insurance 64.04R\r\n").value).to eq "64.04"
      end

      it "should return the correct 'Mygig 1 Internet Promo'" do
        expect(@parser.filter("Mygig 1 Internet Promo 130.70R\r\n").key).to eq "Mygig 1 Internet Promo"
        expect(@parser.filter("Mygig 1 Internet Promo 130.70R\r\n").value).to eq "130.70"
      end

      it "should return the correct 'Clip'" do
        expect(@parser.filter("Clip 8.33R\r\n").key).to eq "Clip"
        expect(@parser.filter("Clip 8.33R\r\n").value).to eq "8.33"
      end

      it "should return the correct 'Calls'" do
        expect(@parser.filter("Calls R 20.98\r\n").key).to eq "Calls"
        expect(@parser.filter("Calls R 20.98\r\n").value).to eq "20.98"
      end

      it "should return the correct 'GPRS'" do
        expect(@parser.filter("GPRS R 58.74\r\n").key).to eq "GPRS"
        expect(@parser.filter("GPRS R 58.74\r\n").value).to eq "58.74"
      end

      it "should return the correct 'Content'" do
        expect(@parser.filter("Content R 3.50\r\n").key).to eq "Content"
        expect(@parser.filter("Content R 3.50\r\n").value).to eq "3.50"
      end
    end
  end

  describe "Pdf input" do
    before do
      @invoice = Invoice::Pdf.new(file: "spec/input/Invoice.pdf", parser: AutoPageParser).serialize
      @parser = AutoPageParser.new(raw: @invoice)
    end

    describe ".invoice_date" do
      it "should return the invoice date" do
        expect(@parser.invoice_date).to eq "1/04/2014"
      end
    end

    describe ".mobile_numbers" do
      it "should return the mobile numbers for the invoice" do
        expect(@parser.mobile_numbers).to eq ["0732635332", "0828741815"]
      end
    end

    describe ".tariff_model" do
      let(:numbers) do
        ["0732635332", "0828741815"]
      end
      
      it "should return the tariff model for the mobile number" do
        expect(@parser.tariff_model("0732635332")).to eq "Vodacom Smart XL"
        expect(@parser.tariff_model("0828741815")).to eq "Vodacom 2GB Average Charges - last 3 months"
      end
    end

    describe ".filter" do
      it "should return the correct 'Phone Insurance'" do
        expect(@parser.filter("Phone Insurance 64.04R\r\n").key).to eq "Phone Insurance"
        expect(@parser.filter("Phone Insurance 64.04R\r\n").value).to eq "64.04"
      end

      it "should return the correct 'Mygig 1 Internet Promo'" do
        expect(@parser.filter("Mygig 1 Internet Promo 130.70R\r\n").key).to eq "Mygig 1 Internet Promo"
        expect(@parser.filter("Mygig 1 Internet Promo 130.70R\r\n").value).to eq "130.70"
      end

      it "should return the correct 'Clip'" do
        expect(@parser.filter("Clip 8.33R\r\n").key).to eq "Clip"
        expect(@parser.filter("Clip 8.33R\r\n").value).to eq "8.33"
      end

      it "should return the correct 'Calls'" do
        expect(@parser.filter("Calls R 20.98\r\n").key).to eq "Calls"
        expect(@parser.filter("Calls R 20.98\r\n").value).to eq "20.98"
      end

      it "should return the correct 'GPRS'" do
        expect(@parser.filter("GPRS R 58.74\r\n").key).to eq "GPRS"
        expect(@parser.filter("GPRS R 58.74\r\n").value).to eq "58.74"
      end

      it "should return the correct 'Content'" do
        expect(@parser.filter("Content R 3.50\r\n").key).to eq "Content"
        expect(@parser.filter("Content R 3.50\r\n").value).to eq "3.50"
      end

      it "should remove a description of numeric data only" do
        expect(@parser.filter(" 1 397.37")).to be_nil
      end

      it "should remove a description of ' . Account no'" do
        expect(@parser.filter(" . Account no")).to be_nil
      end

      it "should remove a description of ' Account Number :'" do
        expect(@parser.filter(" Account Number :")).to be_nil
      end

      it "should remove a description of 'R'" do
        expect(@parser.filter("R")).to be_nil
      end
      it "should remove a description of ''" do
        expect(@parser.filter("")).to be_nil
      end
    end
  end
end
