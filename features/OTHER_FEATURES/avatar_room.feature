Feature:Add and remove avatar in a room

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

  When I visit room edit
  And I attach a file
  And I click Upload

  Then Room should have avatar

	But I visit room edit

	When I click Ripristina immagine predefinita
	Then Room should not have avatar