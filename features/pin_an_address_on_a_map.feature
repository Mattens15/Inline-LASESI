Feature:Pin an address on a map
	As a room host 
	I want to use mapbox 
	So that i can pin an address on a map

Scenario:
	Given I am Room Host
	And I have logged in
	And I am creating an event
	When I insert an address
	Then I should see a marker on map

Scenario:
	Given I am Room Host
	And I have logged in
	And I am modifying an event
	When i insert an address
	Then i should see a marker on map 
