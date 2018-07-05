#USER STORY: 27 TAIGA
Feature:
  As a USER 
  I want to JOIN A ROOM 
  so that i can RESERVE A SPOT

@javascript
Scenario:
  Given I am a registered user
  And a room already exists
  And I log in
  And I visit rooms/1
  
  When I click Join 

  Then I should be reserved