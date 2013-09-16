require 'test/unit'
require 'salestaxcalc'

class ItemTest < Test::Unit::TestCase
  def new_item(*args)
    SalesTaxCalc::Item.new(*args)
  end

  def test_attributes
    item = new_item('music CD', 15, 1, 10)
    assert_equal 'music CD', item.name
    assert_equal 15, item.price
    assert_equal 1, item.qty
    assert_equal 10, item.tax
  end

  def test_no_tax
    item = new_item('music CD', 15, 2, 0)
    assert_equal 0, item.taxes
    assert_equal 30, item.total
    assert_equal 30, item.taxed
  end

  def test_with_taxes
    item = new_item('music CD', 15, 2, 10)
    assert_equal 3, item.taxes
    assert_equal 30, item.total
    assert_equal 33, item.taxed
  end

  def test_parse
    item = SalesTaxCalc::Item.parse("1 book at 12.49", 10, 5)
    assert_equal 1, item.qty
    assert_equal "book", item.name
    assert_equal 12.49, item.price
    assert_equal 0, item.tax

    item = SalesTaxCalc::Item.parse("2 music CDs at 14.99", 10, 5)
    assert_equal 2, item.qty
    assert_equal "music CDs", item.name
    assert_equal 14.99, item.price
    assert_equal 10, item.tax

    item = SalesTaxCalc::Item.parse("100 imported bottles at 27.99", 10, 5)
    assert_equal 100, item.qty
    assert_equal "imported bottles", item.name
    assert_equal 27.99, item.price
    assert_equal 15, item.tax

    item = SalesTaxCalc::Item.parse(
      "1 box of imported chocolates at 11.25", 10, 5)
    assert_equal 1, item.qty
    assert_equal "imported box of chocolates", item.name
    assert_equal 11.25, item.price
    assert_equal 5, item.tax
    assert_equal 11.80, item.taxed
  end
end
