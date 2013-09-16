require 'test/unit'
require 'salestaxcalc'

require 'stringio'


class CalcTest < Test::Unit::TestCase
  def new_calc(*args)
    SalesTaxCalc::Calc.new(*args)
  end

  def test_create
    c = new_calc
    assert_equal SalesTaxCalc::SALES_TAX, c.sales_tax
    assert_equal SalesTaxCalc::IMPORT_TAX, c.import_tax
    assert_equal [], c.items

    c = new_calc(15, 0)
    assert_equal 15, c.sales_tax
    assert_equal 0, c.import_tax
  end

  def test_add
    c = new_calc
    c.add('music CD', 14.99, 1, true, false)
    assert_equal 1, c.items.size
  end

  def test_totals
    c = new_calc(10, 5)
    c.add('music CD', 15, 1, true, false)
    c.add('imported book', 13, 2, false, true)
    assert_equal 1.5 + 26 * 0.05, c.taxes
    assert_equal 15 + 13 * 2, c.total
  end

  def test_input1
    input = <<-EOI
    1 book at 12.49
    1 music CD at 14.99
    1 chocolate bar at 0.85
    EOI
    expected = <<-EOO
    1 book: 12.49
    1 music CD: 16.49
    1 chocolate bar: 0.85
    Sales Taxes: 1.50
    Total: 29.83
    EOO
    out = StringIO.new
    new_calc(10, 5).parse(input).print(out)
    assert_equal expected.lines.map(&:strip).join("\n"), out.string.strip
  end

  def test_input2
    input = <<-EOI
    1 imported box of chocolates at 10.00
    1 imported bottle of perfume at 47.50
    EOI
    expected = <<-EOO
    1 imported box of chocolates: 10.50
    1 imported bottle of perfume: 54.65
    Sales Taxes: 7.65
    Total: 65.15
    EOO
    out = StringIO.new
    new_calc(10, 5).parse(input).print(out)
    assert_equal expected.lines.map(&:strip).join("\n"), out.string.strip
  end

  def test_input3
    input = <<-EOI
    1 imported bottle of perfume at 27.99
    1 bottle of perfume at 18.99
    1 packet of headache pills at 9.75
    1 box of imported chocolates at 11.25
    EOI
    expected = <<-EOO
    1 imported bottle of perfume: 32.19
    1 bottle of perfume: 20.89
    1 packet of headache pills: 9.75
    1 imported box of chocolates: 11.80
    Sales Taxes: 6.65
    Total: 74.63
    EOO
    out = StringIO.new
    new_calc(10, 5).parse(input).print(out)
    assert_equal expected.lines.map(&:strip).join("\n"), out.string.strip
  end
end
