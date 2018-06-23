#USER STORY: 17 TAIGA
Feature: See rooms near me
  As a USER 
  i want to USE MAPBOX 
  so that i can SEE ROOMS IN A DETERMINED RADIUS NEAR ME
  
@javascript
Scenario:
  Given I am a registered user
	And I log in
  When I create a room
  And I visit dashboard
  And I fill radius with 5
  And I fill Search with Via del babuino
	And I pick the first one
  Then I should see marker
