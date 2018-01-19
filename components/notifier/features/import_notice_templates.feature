Feature: Importing/uploading notice templates

  In order to overcome a situation where we have several environments we do not have to create new notices templates
  in evey environments. As an admin with proper hbx_staff role privileges, I should be able to upload notices into environments

  Background:
    Given I have admin privileges
    And I enter into notices page

  Scenario: Successful attempt to upload notices into notice engine
    Given I have a valid CSV/xslx template which downloaded from other environments
    When I click on Upload Notices
    Then I should be able to see a alert window with choose file option
    And I choose the CSV/xslx file
    And I click on Upload button
    Then I should see a flash message saying notice loaded successfully
    And I should be re-direct back to home page of notice engine



