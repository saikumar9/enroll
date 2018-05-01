Feature: Admin can see the enrolled and waived employer's employees in employers list

  Scenario: Admin can see the waived and enrolled employees of employer
    Given Congressional Employer for Soren White exists with active and expired plan year
    And Employee has past hired on date
    And Soren White already matched and logged into employee portal
    When Employee click the "Had a baby" in qle carousel
    And Employee select a qle date based on expired plan year
    Then Employee should see confirmation and clicks continue
    Then Employee should see family members page and clicks continue
    Then Employee should see the group selection page
    When Employee clicks continue on the group selection page
    Then Employee should see the list of plans
    And Soren White should see the plans from the expired plan year
    When Employee selects a plan on the plan shopping page
    Then Soren White should see coverage summary page with qle effective date
    Then Soren White should see the receipt page with qle effective date as effective date
    Then Soren White should see "my account" page with enrollment
    And Soren White logs out
    Given a Hbx admin with read and write permissions exists
    When Hbx Admin logs on to the Hbx Portal
    And the Hbx Admin clicks on the Employers tab
    Then Admin should see the employer record with 1/0 enrolled and waived status