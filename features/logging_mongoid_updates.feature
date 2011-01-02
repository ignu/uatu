Feature: Logging Mongoid edits

  In order to log what my application is doing
  As an ActiveModel model
  Creates and updates are stored

Scenario: Log creates
  Given my current user is "ignu.smith@gmail.com"
  When I create a new Ninja with name "Bruce Lee"
  And  I create a new Ninja with name "Raphael"
  Then I should see the following logs:
    | user                 | action  | type  |
    | ignu.smith@gmail.com | created | Ninja |
    | ignu.smith@gmail.com | created | Ninja |

Scenario: Get logs for a user or entity
  Given my current user is "rodimus@autobots.com"
  When  I create a new Ninja with name "Leonardo"
  Given my current user is "ignu.smith@gmail.com"
  When I create a new Ninja with name "Bruce Lee"
  And  I create a new Vehicle with name "Taurus"
  And  I update Ninja "Leonardo" with "weapon:sai"
  Then I should see the following logs for user "ignu.smith@gmail.com":
    | user                 | action  | type    |
    | ignu.smith@gmail.com | created | Ninja   |
    | ignu.smith@gmail.com | created | Vehicle |
    | ignu.smith@gmail.com | updated | Ninja   |
  And I should see the following logs for ninja "Leonardo":
    | user                 | action  | type  |
    | rodimus@autobots.com | created | Ninja |
    | ignu.smith@gmail.com | updated | Ninja |

Scenario: Log updates
  Given my current user is "ignu.smith@gmail.com"
  When I create a new Ninja with name "Bruce Lee" and weapon "Nunchucks"
  And  I update Ninja "Bruce Lee" with "weapon:sai"
  Then I should see the following logs:
    | user                 | action  | type  | message                                    |
    | ignu.smith@gmail.com | created | Ninja | Created                                    |
    | ignu.smith@gmail.com | updated | Ninja | Changed "weapon" from "Nunchucks" to "sai" |

Scenario: Log collections
  Given my current user is "ignu.smith@gmail.com"
  When I create a new Clan with name "Ninja Turtles"
  And I add "Leonard" to "Ninja Turtles"
  And I update Ninja "Leonard" with "name:Leonardo"
  Then I should see the following logs for clan "Ninja Turtles":
    | user                 | action  | type  | message                                     |
    | ignu.smith@gmail.com | created | Clan  | Created                                     |
    | ignu.smith@gmail.com | added   | Clan  | Added Ninja "Leonard"                       |
    | ignu.smith@gmail.com | updated | Ninja | Changed "name" from "Leonard" to "Leonardo" |

