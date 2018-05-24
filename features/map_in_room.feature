Feature: See the Room's location
  As a USER 
  I want to USE MAPBOX 
  So that i can SEE WHERE THE EVENT IS LOCATED ON A MAP

Scenario:
  Given I am a registered user
  When I log in
  And I visit a room page
  Then I should see room's location on map
