@navigation @ie @safari @production
Feature: Navigation around the website
  As a user
  I want to be able to navigate around the website
  So that I can find the page I'm looking for

  @sanity
  Scenario: Navigate to book details page
    Given I am on the home page
    When I select a book to view book details
    Then details page of the corresponding book is displayed
    And details of above book are displayed

  @sanity
  Scenario: Navigate to a Category page
    Given I am on Categories page
    When I click on a category
    Then Category page is displayed for the selected category

  @sanity
  Scenario: Read a sample
    Given I am on the Book Details page of a paid book
    And the book reader is displayed
    And I am able to read the sample of corresponding book

  @production @CWA-2074
  Scenario: Clicking browser back should load previous search results pages if any
    Given I am on the home page
    When I search for following words
      | words     |
      | da vinci  |
      | dan brown |
    And I press browser back
    And I should see search results page for "da vinci" - pending CWA-2074

  Scenario: Search word should not visible upon user navigating to another page
    Given I am on the home page
    When I search for "dan brown"
    Then "dan brown" should be visible in search bar
    And I click on the Categories header tab
    Then search term should not be visible in search bar

  Scenario: Promotable category - Daily bestsellers
    Given I am on the Bestsellers page
    And I should see Promotions section header as Daily bestsellers
    And I should see 5 books being displayed

  @production
  Scenario: Bestsellers page - Switching views
    When I click on the Bestsellers header tab
    Then Bestsellers page is displayed
    And I select grid view
    Then I should see Fiction books in grid view
    And I select list view
    Then I should see Fiction books in list view

  Scenario: Redesigned footer is displayed
    When I look at the footer
    Then the Help & Support footer visual should be displayed
    Then the How it Works footer visual should be displayed
    Then the Tesco Clubcard footer visual should be displayed
    Then the Redeem Code footer visual should be displayed

  @CWA-34 @manual
  Scenario:Book Component-List view Title display
    When I click on the Bestsellers header tab
    Then Bestsellers page is displayed
    And I select list view
    Then long titles should be displayed in two lines

  @CWA-34 @manual
  Scenario:Book Component-Grid view Title display
    When I click on the Bestsellers header tab
    Then Bestsellers page is displayed
    And I select grid view
    Then long titles should be truncated to fit within image

  @unstable
  Scenario Outline: Click on new release, free ebooks and authors tabs and verify pagination is shown
    When I click on the <page> header tab
    Then pagination is displayed

  Examples:
    | page         |
    | Authors      |
    | Free eBooks  |
    | New releases |

  @CWA-71 @production
  Scenario Outline: Bestsellers page - View not changing between tabs
    Given I am on the Bestsellers page
    When I select <view> view
    Then I should see Fiction books in <view> view
    When I click on Non-Fiction tab
    Then I should see Non-Fiction books in <view> view

    Examples:
      | view |
      | grid |
      | list |

