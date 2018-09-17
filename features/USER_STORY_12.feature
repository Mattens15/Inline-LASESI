#USER STORY 12 TAIGA
Feature: I want to receive a direct message

Scenario:
	Given I am a registered user
	And user Antonio exists
	And I log in
	And a conversation with Antonio exists
	When Antonio sends me a direct
	Then I should receive a new direct