Feature:
  As a ROOM HOST
  I want to USE GOOGLE CALENDAR
  So that I can TRACK AND SET RECURRENT EVENTS
  
Scenario:
  Given I am a registered user
  When I log in
  And I visit create a Room page
  Then I should see calendar
  And I can choose a date and time
  And I can choose to set and event recurrent
