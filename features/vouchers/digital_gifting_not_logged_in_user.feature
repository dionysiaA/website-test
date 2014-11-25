Feature: Voucher code redemption

  As a new or an existing logged out user of blinkbox books
  I want to be able to add a voucher code in the registration/sign in flow
  So I can get my account credited by £5.00.

  Background:
    Given I am not signed in
    And I am on the Voucher Redemption page

  @smoke @manual
  Scenario: New user adding the voucher during the registration flow
    When I submit a valid voucher code <code>
    Then the Registration form should be displayed
    When I fill the registration details
    And I click on Sign up
    Then I should be registered
    When I confirm the voucher code redemption in stage two
    Then my account should be credited by £5

  @smoke @manual
  Scenario: Returning user adding the voucher during the sign in flow
    When I enter a valid voucher code
    And I click on Use this code
    Then the Registration form should be displayed
    But if I already have an account
    And I enter details to sign in
    Then I am successfully signed in
    When I confirm the voucher code redemption in stage two
    Then my account should be credited by £5


  #Negative Scenarios
  #------------------

  @negative @smoke
  Scenario: New user adding a voucher code that has already been used during the registration flow
    Given I submit an already used voucher code
    Then the Registration form should be displayed
    When I fill the registration details
    And I click on Sign up
    Then "is past its use by date. Sorry, it's no longer valid." message is displayed

  @negative @smoke
  Scenario: Returning user adding a voucher code that has already been used during the sign in flow
    Given I submit an already used voucher code
    Then the Registration form should be displayed
    But if I already have an account
    And I sign in with an exiting account
    Then "is past its use by date. Sorry, it's no longer valid." message is displayed

  @negative @smoke @production
  Scenario: New user trying to add voucher code but gets an error during the registration process
    Given I submit an already used voucher code
    Then the Registration form should be displayed
    When I fill the registration details
    But type passwords that are less than 6 characters
    And I click on Sign up
    Then the registration is not successful
    And "Your password is too short" message is displayed

  @negative @smoke @production
  Scenario: Returning user adding the voucher code but gets an error during the sign in process
    Given I submit an already used voucher code
    And if I already have an account
    But I try and sign in without a password
    Then "Please enter your password" message is displayed

