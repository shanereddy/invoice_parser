#!/usr/bin/env ruby

require 'json'
require_relative "../lib/invoice"
require_relative "../lib/parser"

invoice = Invoice::Text.new(file: "../input/original.txt", parser: AutoPageParser)
puts JSON.pretty_generate(invoice.parse("#{ARGV[0]}"))
