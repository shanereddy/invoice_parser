A take on parsing an invoice from a mobile network provider using just plain old ruby
This project structure really works well for me:

|-- Gemfile
|-- Gemfile.lock
|-- README.md
|-- bin
|   |-- translate_invoice_pdf.rb
|   `-- translate_invoice_text.rb
|-- input
|   |-- Invoice.pdf
|   `-- original.txt
|-- lib
|   |-- invoice.rb
|   |-- parser.rb
|   `-- reporter.rb
`-- spec
    |-- auto_page_parser_spec.rb
    |-- input
    |   |-- Invoice.pdf
    |   `-- original.txt
    |-- invoice_spec.rb
    |-- parser_spec.rb
    `-- reporter_spec.rb
