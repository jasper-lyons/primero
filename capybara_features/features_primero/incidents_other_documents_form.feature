#JIRA PRIMERO-566
#JIRA PRIMERO-736

@javascript @primero
Feature: Incidents Other documents form
  As a social user I want to upload documents that are not photos or audio files and enter a description of the document.

  Scenario: I upload an executable file
    Given I am logged in as a social worker with username "primero_mrm" and password "primero"
    When I access "incidents page"
    And I press the "New Incident" button
    And I press the "Other Documents" button
    Then I attach a document "capybara_features/resources/exe_file.exe" for "incident"
    And I should see "Executable files are not allowed." on the page

  Scenario: I upload a document file with the incorrect size
    Given I am logged in as a social worker with username "primero_mrm" and password "primero"
    When I access "incidents page"
    And I press the "New Incident" button
    And I press the "Other Documents" button
    Then I attach a document "capybara_features/resources/huge.jpg" for "incident"
    And I should see "Please upload a document smaller than 10mb" on the page

  Scenario: Uploading multiple documents
    Given I am logged in as a social worker with username "primero_mrm" and password "primero"
    When I access "incidents page"
    And I press the "New Incident" button
    And I click the "Other Documents" link
    And I attach the following documents for "incident":
      |capybara_features/resources/jorge.jpg|Document 1 (jorge.jpg)|
      |capybara_features/resources/jeff.png |Document 2 (jeff.png) |
    Then I press "Save"
    And I should see a success message for new Incident
    And I should not see "Click the EDIT button to add Other Documents"
    And I click the "Other Documents" link
    And I should see documents on the show page:
      |jorge.jpg|Document 1 (jorge.jpg)|
      |jeff.png |Document 2 (jeff.png) |
    And I follow "Edit"
    And I click the "Other Documents" link
    And I should see "jorge.jpg" on the page
    And I should see "jeff.png" on the page

  Scenario: Uploading more documents than allowed
    Given I am logged in as a social worker with username "primero_mrm" and password "primero"
    When I access "incidents page"
    And I press the "New Incident" button
    And I click the "Other Documents" link
    And I attach the following documents for "incident":
      |capybara_features/resources/jorge.jpg|Document 1 |
      |capybara_features/resources/jeff.png |Document 2 |
      |capybara_features/resources/jorge.jpg|Document 3 |
      |capybara_features/resources/jeff.png |Document 4 |
      |capybara_features/resources/jorge.jpg|Document 5 |
      |capybara_features/resources/jeff.png |Document 6 |
      |capybara_features/resources/jorge.jpg|Document 7 |
      |capybara_features/resources/jeff.png |Document 8 |
      |capybara_features/resources/jorge.jpg|Document 9 |
      |capybara_features/resources/jeff.png |Document 10|
    And I should not see "Add another document" on the page
