Feature:Render 404 PAGE if i got error

Scenario:
  Given I am a registered user
  And I log in
	When I visit rooms/19191999
  Then I should see 404