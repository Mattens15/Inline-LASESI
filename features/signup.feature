Feature: signup
    In order to use Inline App
    As a user
    I want to be able to signup

    Scenario: 'Standard signup'
        Given i am not currently logged in
        When I am on the signup page
        Then I should see "Signup"
        And i fill in "Username (required)" with "Mario Rossi"
        And i fill in "Email (required)" with "mario.rossi@gmail.com"
        And i fill in "Password (required)" with "passwordsegreta"
        And i fill in "Password_confirmation (required)" with "passwordsegreta"
        And i press "Signup"
        Then i should see "Sign Up - Confirm Your Account"
        Then i should be on the root page
        Then "mario.rossi@gmail.com" should receive an email
        When i open the email
        Then i should see "Confirm my account" in the email body
        When i follow "Confirm my account" in the email
        Then i should be on the user profile page
        And i should see "Welcome to Inline App"
