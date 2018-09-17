#USER STORY 38 TAIGA
Feature:I want to see all rooms as an admin
	As an ADMIN i want to HAVE SPECIAL PRIVILEGES 
	so that i can SEE ALL ROOMS


Scenario:
	Given I am an admin
	And I log in
	And a private room already exists
	When I visit dashboard 
	Then I should see room name