Feature: Edit Notice Template

  In order to over come a situation where corrections has to be made to a notice template
  As an Admin with hbx_staff role privileges should be able to edit existing template

  Background:
    Given I have admin privileges
    And I enter into notices page

    Scenario: Successful attempt to edit notice template
      Given There is an existing notice template in notice engine
      And I choose notice which I want to update
      Then I click on edit button under Actions column drop-down of that specific notice
      And I will re-direct to edit_notice_kinds path
      Then I update MPI_Indicator and notice template body
      Then I click on submit button
      Then I should be re-direct to home page of notice engine
