Feature: Adding Product
  As a store administrator
  I want to add new products to the inventory
  So that I can manage my product catalog

  Background:
    Given I am logged in as an administrator
    And I am on the Add Product page
    And the product form is loaded

  @smoke
  Scenario: Check form renders all input fields
    When I view the product form
    Then I should see the following fields:
      name       ,
      description,
      image      ,
      code       ,
      color      ,
      stock      ,
      and,
      category   ,

  @smoke
  Scenario Outline: Check product can be added with valid data
    When I enter "<product_name>" in the name field
    And I enter "<description>" in the description field
    And I enter "<product_code>" in the code field
    And I enter "<color>" in the color field
    And I enter "<stock>" in the stock field
    And I select "<category>" from the category dropdown
    And I upload a valid product image
    And I click the "Save Product" button
    Then I should see success message "Product added successfully"
    And the product should be saved to the database

    Examples:
      | product_name | description           | product_code | color | stock | category  |
      | Laptop       | High performance laptop|LAPtopTT0001 | Black | 10    | Electronics |
      

  
  @smoke
  Scenario Outline: Check category selection
  Given I alredy created this <category> in category page
    When I select "<category>" from the category dropdown
    Then "<category>" should be selected

    Examples:
      | category    |
      | Electronics |
      | Beverages   |
      | Snacks      |
      | Clothing    |

  @regression
  Scenario Outline: Validate image file type restriction
    When I upload a file with "<file_extension>" extension
    Then I should see error message "Invalid image type"
    And the form should not accept the file

    Examples:
      | file_extension |
      | .pdf           |
      | .docx          |
      | .txt           |
      | .exe           |

  @regression
  Scenario: Validate stock number cannot be negative
    When I enter "-5" in the stock number field
    And I click the "Save Product" button
    Then I should see error message "Stock number cannot be negative"
    And the form should not submit

  @regression
  Scenario: Validate description input field for length
    When I enter a description with more than 1000 characters
    Then the description should be displayed with a "Show More" button
    And the full text should be accessible when clicking "Show More" 


  @regression
  Scenario Outline: Validate required fields
    When I leave the "<field_name>" field empty
    And I click the "Save Product" button
    Then I should see coresponding validation message "<error_message>"
    And the form should not submit

    Examples:
      | field_name | error_message        |
      | name       | Product name is required |
      | code       | Product code is required |
      | stock      | Stock number is required |
      | categoy      | category name is required |
