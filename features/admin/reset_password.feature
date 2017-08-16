Feature: Reset password of user
  In order to reset password of the user
  User should have the role of an admin

  Scenario: Admin can reset password of the user if has permission
    Given Hbx Admin exists
    When Hbx Admin logs on to the Hbx Portal
    Then there are 1 preloaded unlocked user accounts
    When Hbx Admin clicks on the User Accounts tab
    Then Hbx Admin should see the list of user accounts and an Action button
    When Hbx Admin clicks on the Action button
    Then Hbx Admin should see Reset Password link on user accounts page
    When Hbx Admin clicks on Reset Password link on user accounts page
    Then the reset password email should be sent to the user
