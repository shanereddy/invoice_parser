#!/usr/bin/env ruby

require 'json'
require_relative "../lib/invoice"
require_relative "../lib/parser"

invoice = Invoice::Pdf.new(file: "../input/Invoice.pdf", parser: AutoPageParser)
puts JSON.pretty_generate(invoice.parse("#{ARGV[0]}"))
