#USER STORY: 20 TAIGA

#AS ROOMHOST I WANT TO HAVE POWER TO ADD AVATAR TO THE ROOM I MANAGE
Feature:Render 404 PAGE if i got error
@javascript
Scenario:
  Given I am a registered user
  And I log in
	When I visit rooms/19191999
  Then I should see 404