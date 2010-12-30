Feature: Logging Mongoid edits

  In order to log what my application is doing
  As an ActiveModel model
  Creates and updates are stored

Scenario: Log creates

  Given my current user is "ignu.smith@gmail.com"
  When I create a new Ninja with name "Bruce Lee"
  And  I create a new Ninja with name "Raphael"
  Then I should see the following logs:
    | user                 | action  | type  | item      |
    | ignu.smith@gmail.com | created | Ninja | Bruce Lee |
    | ignu.smith@gmail.com | created | Ninja | Raphael   |

Scenario: Log updates

  Given my current user is "ignu.smith@gmail.com"
  When I create a new Ninja with name "Bruce Lee" and weapon "Nunchucks"
  And  I update Ninja "Bruce Lee" with "weapon:sai"
  Then I should see the following logs:
    | user                 | action  | type  | item      | message                      |
    | ignu.smith@gmail.com | created | Ninja | Bruce Lee | Created                      |
    | ignu.smith@gmail.com | updated | Ninja | Bruce Lee | Changed "Nunchucks" to "sai" |
