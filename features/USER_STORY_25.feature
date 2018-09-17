#USER STORY 25 TAIGA
Feature:I want to have a reminder sent via email
	As a USER i want to BE NOTIFIED OF MY INCOMING EVENT 
	so that i can HAVE A REMINDER SENT VIA EMAIL
Scenario:
	Given I am a registered user
	And a room already exists
	And I log in 
	And I visit rooms/1
	And I click Join
	And I click Email 
	Then I should be enlisted in the list of people to remind
