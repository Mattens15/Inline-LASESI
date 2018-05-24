Feature:See rooms in a certain location
	As a User
	I want to Use Mapbox
	So that i can see rooms in a certain location

Scenario:
	Given I am a user
	When I visit the dashbord
	And I write a location
	Then I should see markers on map
	And I should see events in that location
