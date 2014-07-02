require "invoice"
require "parser"

describe Parser do
  before do
    @invoice = Invoice::Text.new(file: "spec/input/original.txt", parser: AutoPageParser).serialize
    @parser = Parser.new(raw: @invoice)
  end

  describe ".capture_block" do
    let(:array) do
      ["Mobile number: 0732635332\r\n", "Tariff Model: Vodacom Smart XL\r\n", "Monthly charges\r\n",
       "Phone Insurance 64.04R\r\n", "    \r\n", "Mygig 1 Internet Promo 130.70R\r\n",
       "Sim Insurance 3.95R\r\n", "Clip 8.33R\r\n", "Telephony 613.16R\r\n", "R 820.18Usage charges\r\n",
       "Calls R 20.98\r\n", "GPRS R 58.74\r\n", "Content R 3.50\r\n", "R 83.22\r\n", "Subtotal R 903.40\r\n"
      ] 
    end
    
    it "should return monthly charges only" do
      monthly = @parser.capture_block(array, "Monthly charges", "Usage charges")
      expect(monthly).to eq ["Monthly charges\r\n", "Phone Insurance 64.04R\r\n", "    \r\n", "Mygig 1 Internet Promo 130.70R\r\n",
                              "Sim Insurance 3.95R\r\n", "Clip 8.33R\r\n", "Telephony 613.16R\r\n", "R 820.18Usage charges\r\n"
                            ]
    end

    it "should return usage charges only" do
      usage = @parser.capture_block(array, "Usage charges", "Subtotal")
      expect(usage).to eq ["R 820.18Usage charges\r\n", "Calls R 20.98\r\n", 
                           "GPRS R 58.74\r\n", "Content R 3.50\r\n", "R 83.22\r\n",
                           "Subtotal R 903.40\r\n"
                          ]
    end

    it "should return one line for the same start and end pattern" do
      capture = @parser.capture_block(array, "Usage charges", "Usage charges")
      expect(capture).to eq ["R 820.18Usage charges\r\n"]
    end

    it "should return [] for an invalid start pattern" do
      capture = @parser.capture_block(array, "Usae charges", "Usage charges")
      expect(capture).to eq []
    end
  end

end
