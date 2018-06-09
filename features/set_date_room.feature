#USER STORY: 21 TAIGA
Feature:
  As a ROOM HOST
  I want to USE GOOGLE CALENDAR
  So that I can TRACK AND SET RECURRENT EVENTS

@javascript
Scenario:
  Given I am a registered user
  And I log in
  When I visit rooms/new
  Then I should see calendar
  And I can choose a date and time
  And I can choose to set and event recurrent
