module SalesTaxCalc
  VERSION = "0.0.1"

  SALES_TAX = 10  # 10% standard sales tax
  IMPORT_TAX = 5  # 5% for imported products

  # Non-taxable items by the standard tax rate
  RE_NOTAX = /books?|chocolates?|pills?/i

  # Rounds up/down the num to specified precision step.
  # round(3.36, 0.05) => 3.35
  # round(3.33) => 3.35
  # round(3.32) => 3.30
  def self.round(num, precision=0.05)
    (num * (1/precision)).round * precision
  end

  class Item
    attr_reader :name, :price, :qty, :tax

    # RegExp to match an input line
    RE = /^(\d+)\s+(.+)\sat\s([0-9]+(\.[0-9]+)?)/i
    
    def initialize(name, price, qty, tax)
      @name = name
      @price = price.to_f
      @qty = qty.to_i
      @tax = tax.to_f
    end

    def self.parse(line, stax, itax)
      m = RE.match(line.to_s.strip)
      name = m[2].to_s
      tax = (RE_NOTAX =~ name).nil? ? stax : 0
      if name.sub!(/import(ed)?(\s*)?/, '')
        name = 'imported ' + name
        tax += itax
      end
      new(name, m[3].to_f, m[1].to_i, tax)
    end

    def taxes
      @taxes ||= SalesTaxCalc.round(tax * total / 100.0)
    end

    def total
      @total ||= price * qty
    end

    def taxed
      @taxed ||= total + taxes
    end
  end

  class Calc
    attr_reader :sales_tax, :import_tax, :items

    def initialize(sales_tax = SALES_TAX, import_tax = IMPORT_TAX)
      @sales_tax = sales_tax
      @import_tax = import_tax
      @items = []
    end

    def parse(text)
      parsed = text.lines.map { |line|
        Item.parse(line.chomp, sales_tax, import_tax)
      }
      @items.push(*parsed)
      self
    end
    
    def add(name, price, qty, taxable, imported)
      tax = taxable ? sales_tax : 0
      tax += import_tax if imported
      @items << Item.new(name, price, qty, tax)
    end

    def taxes
      sum(:taxes)
    end

    def total
      sum(:total)
    end

    def taxed
      sum(:taxed)
    end

    def print(out)
      items.each do |item|
        out.printf("%d %s: %.2f\n", item.qty, item.name, item.taxed)
      end
      out.printf("Sales Taxes: %.2f\n", taxes)
      out.printf("Total: %.2f\n", taxed)
      self
    end

    private

    def sum(meth)
      @items.inject(0) { |sum, i| sum + i.send(meth) }
    end
  end
end
