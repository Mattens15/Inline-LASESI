#USER STORY: 31 TAIGA
Feature:
  As a ROOM HOST
  I want to PROMOTE ANOTHER USER TO ROOM HOST 
  So that HE CAN HAVE HOST PRIVILEGES

@javascript
Scenario:
  Given I am a registered user
	And user Owner exists
  And I log in
	And I click create
  And I fill room_name with Giorgio
  And I fill room_max_participants with 5
	And I select TimeFrom
	And I select TimeTo
	And I fill Search with Via del babuino
	And I pick the first one
	And I click Submit

  When I visit rooms/1/edit
  And I fill power_user_id with Owner

  Then Owner should be room host