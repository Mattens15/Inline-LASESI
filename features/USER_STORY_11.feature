#User story 11 taiga

Feature: I want to messagr another user
	As a USER i want to HAVE PRIVATE MESSAGES 
	so that i can MESSAGE ANOTHER USER


Scenario:
	Given I am a registered user
	And user Michele exists
	And I log in
	And a conversation with Michele exists 
	When I send Michele a direct
	Then Michele should receive a new direct
