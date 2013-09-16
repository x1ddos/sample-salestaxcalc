require 'salestaxcalc'
require 'stringio'

Given /empty basket/i do
  @receipt = SalesTaxCalc::Calc.new
end

Given /purchase (.*)$/i do |item|
  @receipt.parse(item)
end

When /print/i do
  @out = StringIO.new
  @receipt.print(@out)
end

Then /should see/ do |printout|
  assert_equal printout.strip, @out.string.strip
end 
