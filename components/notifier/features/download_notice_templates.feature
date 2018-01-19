Feature: Downloading notice templates

  In order to overcome a situation where we have several environments we do not have to create new notices templates
  in evey environments. As an admin with proper hbx_staff role privileges, I should be able to download notices from environments

  Background:
    Given I have admin privileges
    And I enter into notices page

    Scenario: Successful attempt to download notices from notice engine
      Given There exist 3 notices under notice templates
      When I  will choose the notice(s) template(s) which I want to download
      And I choose checkbox from the table
      And I click on bulk actions button
      And I choose download button
      Then There should file under downloads



