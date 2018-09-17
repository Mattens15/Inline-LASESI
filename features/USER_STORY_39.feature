#USER STORY 39 TAIGA
Feature:I want to suspend the website
	As an ADMIN 
	i want to HAVE SPECIAL SETTINGS 
	so that i can SUSPEND THE WEBSITE
Scenario:
	Given I am an admin
	And I log in
	And I visit dashboard
	And I click Suspend website
	Then the website should be suspended
	And I click Restore website
	Then the website should be restored
	 