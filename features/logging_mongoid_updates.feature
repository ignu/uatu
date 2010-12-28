Feature: Logging Mongoid edits

  In order to log what my application is doing
  As an ActiveModel model
  Creates and updates are stored

Scenario: Log creates and updates

  Given my current user is "ignu.smith@gmail.com"
  When I create a new Ninja with name "Bruce Lee"
  And  I create a new Ninja with name "Raphael"
  Then I should see the following logs:
    | user                 | action  | type  | item      |
    | ignu.smith@gmail.com | created | Ninja | Bruce Lee |
    | ignu.smith@gmail.com | created | Ninja | Raphael   |
