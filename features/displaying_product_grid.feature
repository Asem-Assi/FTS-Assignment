@smoke @high-priority
Feature: Product Listing and Management
  As a store administrator
  I want to view and manage products in a grid layout
  So that I can easily browse and manage my inventory

  Background:
    Given I am logged in as an administrator
    And I am on the Product page
    And the product list table is visible

  @smoke @high-priority
  Scenario Outline: Check column sorting for numbers and text
    When I click on the "<column>" column header
    Then the products should be sorted by "<column>" in ascending order
    When I click on the "<column>" column header again
    Then the products should be sorted by "<column>" in descending order

    Examples:
      | column |
      | Price  |
      | Name   |
      | Code   |
      | Tax    |

  @smoke @high-priority
  Scenario Outline: Check product search functionality
    When I enter "<search_term>" in the search input field
    Then only products containing "<search_term>" should be displayed
    When I clear the search input field
    Then all products should be displayed

    Examples:
      | search_term |
      | Milk       |
    

  @smoke @high-priority
  Scenario Outline: Verify category change update
    Given a product exists with category "<old_category>"
    When I edit the product
    And I change the category from "<old_category>" to "<new_category>"
    And I save the changes
    And I return to the Product list page
    Then the product should display with category "<new_category>"
    And the category change should be reflected immediately in the list view

    Examples:
      | old_category | new_category |
      | Electronics  | Clothing     |
     

  @smoke @high-priority
  Scenario: Verify correct pagination navigation
    Given the product list has more than 5 entries
    When I set "Show entries" to 5
    And I click "Next" on pagination
    Then I should navigate to page 2

  @smoke @high-priority
  Scenario: Edit product from product grid
    Given a product exists in the product list
    When I click the "Edit" button for the product
    Then I should be redirected to the edit product page
    And the product details should be pre-filled in the form
    When I modify the product name to "Updated Product Name"
    And I change the price to "29.99"
    And I click "Save Changes"
    Then I should see success message "Product updated successfully"
    And the changes should be reflected in the product list

  @smoke @high-priority
  Scenario: Delete product from product grid
    Given a product exists in the product list
    When I click the "Delete" button for the product
    Then I should see a confirmation dialog
    When I confirm the deletion
    Then the product should be removed from the list
    And I should see success message "Product deleted successfully"

  @smoke @high-priority
  Scenario: Delete category and verify product list update
    Given a category "Electronics" exists with products
    When I delete the category "Electronics"
    Then I should see confirmation dialog for category deletion
    When I confirm the category deletion
    Then the category should be deleted
    And products in that category should show "No Category" or be moved to default category
    And the product list should update to reflect the category change

  @smoke @high-priority
  Scenario: Modify category and verify product list update
    Given a category "Electronics" exists with products
    When I edit the category "Electronics"
    And I change the category name to "Digital Electronics"
    And I save the category changes
    Then the category should be updated to "Digital Electronics"
    And all products in that category should show the new category name in the product list
    And the product list should update immediately to reflect the category change

  @smoke @high-priority
  Scenario: Filter products by date range
    Given products exist with different creation dates
    When I select "Date Range" from the filter dropdown
    And I enter "2024-01-01" as start date
    And I enter "2024-12-31" as end date
    And I click "Apply Filter"
    Then I should see only products created within the specified date range
    And the product count should reflect the filtered results

  @smoke @high-priority
  Scenario: Filter products by today's date
    Given products exist with today's creation date
    When I select "Today" from the date filter dropdown
    And I click "Apply Filter"
    Then I should see only products created today
    And the date filter should show "Today" as selected

  @smoke @high-priority
  Scenario: Filter products by this week
    Given products exist within this week
    When I select "This Week" from the date filter dropdown
    And I click "Apply Filter"
    Then I should see only products created this week
    And the date filter should show "This Week" as selected

  @smoke @high-priority
  Scenario: Filter products by this month
    Given products exist within this month
    When I select "This Month" from the date filter dropdown
    And I click "Apply Filter"
    Then I should see only products created this month
    And the date filter should show "This Month" as selected

  @regression @high-priority
  Scenario Outline: Validate date filter with invalid dates
    When I select "Date Range" from the filter dropdown
    And I enter "<start_date>" as start date
    And I enter "<end_date>" as end date
    And I click "Apply Filter"
    Then I should see validation message "<error_message>"
    And the filter should not be applied

    Examples:
      | start_date | end_date   | error_message                    |
      | 2024-13-01 | 2024-12-31 | Invalid start date format      |
      | 2024-01-01 | 2024-13-31 | Invalid end date format        |
      | 2024-12-31 | 2024-01-01 | End date cannot be before start date |

  @regression @high-priority
  Scenario: Clear date filter
    Given a date filter is currently applied
    When I click "Clear Filter" button
    Then the date filter should be cleared
    And all products should be displayed

 

  @regression @medium-priority
  Scenario: Date filter with no results
    Given no products exist for the selected date range
    When I select "Date Range" from the filter dropdown
    And I enter "2020-01-01" as start date
    And I enter "2020-12-31" as end date
    And I click "Apply Filter"
    Then I should see "No products found" message
    And the product list should be empty
    And the filter should remain applied 