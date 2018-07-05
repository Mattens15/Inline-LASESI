#USER STORY: 20 TAIGA
Feature: See incoming events
  As a USER 
  I want to USE GOOGLE CALENDAR 
  So that i can SEE INCOMING EVENTS

Scenario:
  Given I am a registered user
  And a room already exists
  And I am alreay reserved
  
  When I log in
  And I visit my profile

  Then I should see room name