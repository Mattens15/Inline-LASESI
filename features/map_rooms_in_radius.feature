Feature: See rooms near me
  As a USER 
  i want to USE MAPBOX 
  so that i can SEE ROOMS IN A DETERMINED RADIUS NEAR ME
  
Scenario:
  Given I am a registered user
  When I log in
  And I visit the map page
  And I write the radius
  And I use the geolocator
  Then I should see markers on map
