Feature: Print receipt
  When I purchase items I receive a receipt which lists the name of all the
  items and their price (including tax), finishing with the total cost of the
  items, and the total amounts of sales taxes paid. The rounding rules for
  sales tax are that for a tax rate of n%, a shelf price of p contains
  (np/100 rounded up to the nearest 0.05) amount of sales tax.

  Scenario: Input 1
    Given an empty basket
    When I purchase 1 book at 12.49
    And I purchase 1 music CD at 14.99
    And I purchase 1 chocolate bar at 0.85
    And I print the receipt
    Then I should see 
      """
      1 book: 12.49
      1 music CD: 16.49
      1 chocolate bar: 0.85
      Sales Taxes: 1.50
      Total: 29.83
      """

  Scenario: Input 2
    Given an empty basket
    When I purchase 1 imported box of chocolates at 10.00
    And I purchase 1 imported bottle of perfume at 47.50
    And I print the receipt
    Then I should see 
      """
      1 imported box of chocolates: 10.50
      1 imported bottle of perfume: 54.65
      Sales Taxes: 7.65
      Total: 65.15
      """

  Scenario: Input 3
    Given an empty basket
    When I purchase 1 imported bottle of perfume at 27.99
    And I purchase 1 bottle of perfume at 18.99
    And I purchase 1 packet of headache pills at 9.75
    And I purchase 1 box of imported chocolates at 11.25
    And I print the receipt
    Then I should see 
      """
      1 imported bottle of perfume: 32.19
      1 bottle of perfume: 20.89
      1 packet of headache pills: 9.75
      1 imported box of chocolates: 11.80
      Sales Taxes: 6.65
      Total: 74.63
      """
