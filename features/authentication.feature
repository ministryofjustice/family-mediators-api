Feature: Only authenticated users can use the admin interface. The API is public and is not authenticated

  Scenario: Redirect user to originally requested page after logging in
    Given I am an unauthenticated user
    When I attempt to view some unrestricted content
    Then I am shown a login form
    When I authenticate with valid credentials
    Then I should be shown the restricted content
