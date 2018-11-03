require "application_system_test_case"

class PeopleTest < ApplicationSystemTestCase
  setup do
    @person = people(:one)
  end

  test "visiting the index" do
    visit people_url
    assert_selector "h1", text: "People"
  end

  test "creating a Person" do
    visit people_url
    click_on "New Person"

    fill_in "Address", with: @person.address
    fill_in "Date Of Birth", with: @person.date_of_birth
    fill_in "Description", with: @person.description
    fill_in "Email", with: @person.email
    fill_in "First Name", with: @person.first_name
    fill_in "Last Name", with: @person.last_name
    fill_in "Middle Name", with: @person.middle_name
    fill_in "Phone Number", with: @person.phone_number
    fill_in "Sex", with: @person.sex
    fill_in "Status", with: @person.status
    click_on "Create Person"

    assert_text "Person was successfully created"
    click_on "Back"
  end

  test "updating a Person" do
    visit people_url
    click_on "Edit", match: :first

    fill_in "Address", with: @person.address
    fill_in "Date Of Birth", with: @person.date_of_birth
    fill_in "Description", with: @person.description
    fill_in "Email", with: @person.email
    fill_in "First Name", with: @person.first_name
    fill_in "Last Name", with: @person.last_name
    fill_in "Middle Name", with: @person.middle_name
    fill_in "Phone Number", with: @person.phone_number
    fill_in "Sex", with: @person.sex
    fill_in "Status", with: @person.status
    click_on "Update Person"

    assert_text "Person was successfully updated"
    click_on "Back"
  end

  test "destroying a Person" do
    visit people_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Person was successfully destroyed"
  end
end
