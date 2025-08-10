@smoke
Feature: Point of Sale (POS) Page
  As a cashier
  I want to process sales transactions
  So that I can complete customer purchases efficiently

  Background:
    Given I am logged in as an admin
    And I am on the POS page
    And the POS interface is loaded
    And there are products available for sale

  @smoke
  Scenario: POS page displays product catalog
    When I view the POS page
    Then I should see the product catalog displayed
    And I should see a shopping cart section
    And I should see a payment section

  @smoke
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

  @smoke
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

  @smoke
  Scenario: Update product quantity in cart
    Given a product is in the cart with quantity 1
    When I update the quantity to 3
    Then the quantity should be updated to 3
    And the cart total should reflect the new quantity
    And the stock should be adjusted accordingly

  @smoke
  Scenario: Calculate total with tax
    Given the following products are in the cart:
      | product | quantity | price |
      | Laptop  | 1        | 999.99 |
      | Mouse   | 2        | 29.99  |
    When I view the cart total
    Then I should see subtotal: $1059.97
    And I should see tax: $105.99 (10%)
    And I should see total: $1165.96

  @regression
  Scenario: Remove product from cart
    Given a product is added to the cart
    When I remove the product from the cart
    Then the product should be removed from the cart
    And the cart total should update accordingly
    And the stock should be restored

  @regression
  Scenario: Validate stock quantity during add to cart
    Given a product "Pen" exists with stock quantity 5
    When I input quantity 10 for the product
    Then the system should block the action
    And I should see validation message "Cannot add more units than available stock"
    And the product should not be added to cart

  @regression
  Scenario: Remove product from all carts when deleted
    Given a product "Notebook" exists and is added to carts of multiple users
    When I delete the product "Notebook" from the product page
    Then the product should be removed from all user carts
    And users should no longer see "Notebook" in their carts
    And users should not be able to proceed to checkout with the deleted product
