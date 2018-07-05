#USER STORY: 27 TAIGA
Feature:
  As a USER
  I want to UNJOIN A ROOM
  So that I can CANCEL MY RESERVATION

@javascript
Scenario:
  Given I am a registered user
  And a room already exists
  And I am alreay reserved
  And I log in
  And I visit rooms/1
  
  When I click Unjoin 

  Then I should not be reserved