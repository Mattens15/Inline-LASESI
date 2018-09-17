#USER STORY 42 TAIGA

Feature: Send a chat message
  As a USER
  i want to send a chat message
  so other users can see it

Scenario:
  Given I am a registered user
  And I log in 
  And a room already exists
  And I visit rooms/1
  And I fill chat_input with Hello
  And I click Invia
  Then I should see a new message
