Feature: See the Room's location
  As a USER 
  I want to USE MAPBOX 
  So that i can SEE WHERE THE EVENT IS LOCATED ON A MAP

@javascript
Scenario:
  Given I am a registered user
  And I log in
  When I create a room
  And I visit rooms/1
  Then I should see marker

