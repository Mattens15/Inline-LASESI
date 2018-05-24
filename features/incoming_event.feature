Feature: See incoming events
  As a USER 
  I want to USE GOOGLE CALENDAR 
  So that i can SEE INCOMING EVENTS

Scenario:
  Given I am a registered user
  When I log in
  And I visit the calendar page
  Then I should see Calendar
  And incoming events
