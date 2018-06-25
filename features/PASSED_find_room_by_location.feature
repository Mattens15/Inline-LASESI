#USER STORY: 18 TAIGA
Feature:See rooms in a certain location
	As a User
	I want to Use Mapbox
	So that i can see rooms in a certain location



@javascript
Scenario:
	Given I am a registered user
  And I log in
	When I create a room
	And I visit dashboard
	And I fill Search with Via del babuino
	And I pick the first one
	Then I should see marker
