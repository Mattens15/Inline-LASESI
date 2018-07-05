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
  And I fill room_name with Giorgio
	And I fill room_max_participants with 5
	And I select TimeFrom
	And I select TimeTo
  And I select the recurrence
  And I click Submit
  Then I should be on room page
  And Room should have multiple instances
#STILL NO IMPLEMENTED