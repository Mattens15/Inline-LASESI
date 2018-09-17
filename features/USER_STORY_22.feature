#USER STORY 22 TAIGA

Feature:As a room host I want to pin a message
As a ROOM HOST i want to HAVE SPECIAL PRIVILEGES so that i can PIN A MESSAGE

Scenario:
	Given I am a registered user
	And I log in 
	And I click create
	And I fill room_name with Giorgio
    And I select TimeFrom
    And I select TimeTo
    And I fill Search with Via del babuino
    And I pick the first one
    And I click Submit                     
    And I visit rooms/1
    And I fill chat_input with Hello
    And I click Invia 
    And I click pin_message
    When I visit rooms/1
    Then I should see a pinned message                     
