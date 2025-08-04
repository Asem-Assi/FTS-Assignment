@smoke @high-priority
Feature: Point of Sale (POS) Page
  As a cashier
  I want to process sales transactions
  So that I can complete customer purchases efficiently

  Background:
    Given I am logged in as an admin
    And I am on the POS page
    And the POS interface is loaded
    And there are products available for sale

  @smoke @high-priority
  Scenario: POS page displays product catalog
    When I view the POS page
    Then I should see the product catalog displayed
    And I should see a shopping cart section
    And I should see a payment section

  @smoke @high-priority
  Scenario: Validate stock quantity during add to cart
    Given a product "Pen" exists with stock quantity 5
    When I input quantity 10 for the product
    And I click "Add to Cart"
    Then the system should block the action
    And I should see validation message "Cannot add more units than available stock"
    And the product should not be added to cart

  @smoke @high-priority
  Scenario: Verify product behaves correctly when added to multiple carts
    Given a product "Product X" exists with stock quantity 100
    When I create Cart A
    And I add "Product X" with quantity 10 to Cart A
    And I create Cart B
    And I add "Product X" with quantity 10 to Cart B
    Then both carts should function correctly and independently
    And Cart A should show correct total for 10 units
    And Cart B should show correct total for 10 units
    And there should be no duplication between carts
    And the UI should display correct totals for each cart

  @smoke @medium-priority
  Scenario Outline: Add products to cart with valid stock
    Given a product "<product_name>" exists with stock quantity "<stock>"
    When I add "<product_name>" with quantity "<quantity>" to cart
    Then the product should be added successfully
    And the cart total should update correctly
    And the stock should be reduced by "<quantity>"

    Examples:
      | product_name | stock | quantity |
      | Laptop       | 10    | 1        |
      | Mouse        | 25    | 3        |
      | Coffee       | 50    | 5        |

  @smoke @medium-priority
  Scenario: Update product quantity in cart
    Given a product is in the cart with quantity 1
    When I update the quantity to 3
    Then the quantity should be updated to 3
    And the cart total should reflect the new quantity
    And the stock should be adjusted accordingly

  @smoke @high-priority
  Scenario: Calculate total with tax
    Given the following products are in the cart:
      | product | quantity | price |
      | Laptop  | 1        | 999.99 |
      | Mouse   | 2        | 29.99  |
    When I view the cart total
    Then I should see subtotal: $1059.97
    And I should see tax: $105.99 (10%)
    And I should see total: $1165.96

  @smoke @high-priority
  Scenario: Process payment with cash
    Given the cart total is $1165.96
    When I select "Cash" as payment method
    And I enter $1200.00 as cash received
    And I click "Complete Sale"
    Then I should see change due: $34.04
    And the sale should be completed successfully
    And a receipt should be generated

  @smoke @high-priority
  Scenario: Process payment with card
    Given the cart total is $1165.96
    When I select "Credit Card" as payment method
    And I enter valid card details
    And I click "Complete Sale"
    Then the payment should be processed
    And the sale should be completed successfully
    And a receipt should be generated

  @smoke @high-priority
  Scenario: Apply discount to sale
    Given the cart total is $1165.96
    When I apply a 10% discount
    Then the discount should be applied: $116.60
    And the final total should be $1049.36

  @smoke @high-priority
  Scenario: Void transaction
    Given a sale is in progress
    When I click "Void Transaction"
    Then I should see confirmation dialog
    When I confirm the void action
    Then the transaction should be voided
    And the cart should be cleared
    And no sale should be recorded

  @regression @high-priority
  Scenario: Remove product from cart
    Given a product is added to the cart
    When I remove the product from the cart
    Then the product should be removed from the cart
    And the cart total should update accordingly
    And the stock should be restored

  


 
  