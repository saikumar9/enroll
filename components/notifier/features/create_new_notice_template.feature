Feature: Create New Notice Template

  In order to trigger a notice to either employer or employee or broker we need to create a template
  As an admin with proper hbx_staff role privileges, I want notice engine create new notice functionality

  Background:

    Given Hbx Admin exists
    When Hbx Admin logs on to the Hbx Portal
    And Hbx Admin clicks on the Notices tab

    Scenario: Successful creation of notice template using notice engine
      When I click on Add Notice
      And I Enter MPI Indicator, Title, description details
      And I Choose Employer as my recipient
      And I Enter the Template body using cke-editor tokens
      And I click on submit button
      Then I should be re-direct to home page of notice engine
      And I should see flash message saying notice created successfully
      And I should see newly added notice
      When I click notice title
      Then I should see notice preview

    Scenario: Failure attempt on creation of a notice template using notice engine
      When I click on Add Notice
      And I Enter MPI Indicator, Title, description details
      But MPI Indicator is already taken
      And I choose Employer as my recipient
      And I enter the template body using cke-editor tokens
      And I click on submit button
      Then I should see flash message saying MPI-Indicator already taken