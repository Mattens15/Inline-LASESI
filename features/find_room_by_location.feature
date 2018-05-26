Feature:See rooms in a certain location
	As a User
	I want to Use Mapbox
	So that i can see rooms in a certain location

Scenario:
	Given I am a registered user
        And I log in
	When I visit the map page
	And I search a location
	Then I should see markers
