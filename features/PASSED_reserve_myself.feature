#USER STORY: 26 TAIGA
Feature:Reserve myself
	As a USER
	I want to JOIN A room
	So that i can RESERVE A SPOT


@javascript
Scenario:
	Given I am a registered user
	And a room already exists
	And I log in
  
	And I visit rooms/1
	And I click Join

	Then I should be reserved
	
