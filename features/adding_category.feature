@smoke
Feature: Category Management
  As a store administrator
  I want to manage product categories
  So that I can organize my products effectively

  Background:
    Given I am logged in as an administrator
    And I am on the Category Management page

  @smoke
  Scenario: Create new category
    When I click "Add Category" button
    And I enter "Electronics" in the category name field
    And I click "Submit"
    Then I should see success message "Category created successfully"
    And the category should be saved to the database
    And the category should appear in the category list

  @smoke
  Scenario: Update existing category
    Given a category "Electronics" exists
    When I click "Edit" for the category "Electronics"
    And I change the name to "Digital Electronics"
    And I click "Save Changes"
    Then I should see success message "Category updated successfully"
    And the category should be updated in the database
    And all products in this category should reflect the new category name

  @smoke
Scenario: Delete category with products
  Given a category "Electronics" exists with products
  When I click "Delete" for the category "Electronics"
  And I confirm the deletion in the confirmation dialog
  Then I should see success message "Category deleted successfully"
  And the category should be removed from the database
  And the products in that category should be moved to "Uncategorized" or display "No Category"


  @smoke
  Scenario: Delete category without products
    Given a category "Test Category" exists without any products
    When I click "Delete" for the category "Test Category"
    And I confirm the deletion
    Then I should see success message "Category deleted successfully"
    And the category should be completely removed from the database

  @smoke 
  Scenario: View category list
    Given multiple categories exist in the system
    When I view the category list
    Then I should see all categories displayed
    And I should see category name, And when they created

  @smoke 
Scenario: Search categories with a term
  When I enter "Electronics" in the category search field
  Then I should see only categories containing "Electronics"

@smoke 
Scenario: Clear the category search field
  When I clear the search field
  Then I should see all categories again


  @regression
  Scenario Outline: Sorting categories based on column
    Given I'm at category page
    When I click on "<column>" then it should sort the rows ascending
    When I click on "<column>" again it should sort rows descending

    Examples:
      | column        |
      | Created at    |
      | Category name |

  @regression
  Scenario Outline: Validate category name requirements
    When I click "Add New Category"
    And I enter "<category_name>" in the category name field
    And I click "Save Category"
    Then I should see validation message "<error_message>"
    And the category should not be saved

    Examples:
      | category_name | error_message           |
      |               | Category name is required |
      | A             | Category name too short  |
      | Very Long Category Name That Exceeds Maximum Length | Category name too long |

  @regression
  Scenario: Validate duplicate category name
    Given a category "Electronics" already exists
    When I click "Add New Category"
    And I enter "Electronics" in the category name field
    And I click "Save Category"
    Then I should see validation message "Category name already exists"
    And the category should not be saved
