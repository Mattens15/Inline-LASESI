#USER STORY: 19 TAIGA
Feature:Pin an address on a map
	As a room host 
	I want to use mapbox 
	So that i can pin an address on a map

@javascript
Scenario:
	Given I am a registered user
	And I log in
  
	When I click create
	
	And I fill room_name with Giorgio
	And I fill room_max_participants with 5
	And I select TimeFrom
	And I select TimeTo
	And I fill Search with Via del babuino
	And I pick the first one
	And I click Submit

	Then room has coordinates
