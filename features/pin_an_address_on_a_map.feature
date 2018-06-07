Feature:Pin an address on a map
	As a room host 
	I want to use mapbox 
	So that i can pin an address on a map

@javascript
Scenario:
	Given I am a registered user
	And I log in
  When I click create a room
  And I click on map_control
	And I search a location
	And I save
	Then room contains coordinates
