require 'test/unit'
require 'salestaxcalc'

class RoundTest < Test::Unit::TestCase
  def test_round
    assert_equal 3.35, SalesTaxCalc.round(3.36, 0.05)
    assert_equal 3.35, SalesTaxCalc.round(3.33)
    assert_equal 3.3, SalesTaxCalc.round(3.32).round(3)
  end
end
