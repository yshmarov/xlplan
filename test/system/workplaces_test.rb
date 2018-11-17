require "application_system_test_case"

class WorkplacesTest < ApplicationSystemTestCase
  setup do
    @workplace = workplaces(:one)
  end

  test "visiting the index" do
    visit workplaces_url
    assert_selector "h1", text: "Workplaces"
  end

  test "creating a Workplace" do
    visit workplaces_url
    click_on "New Workplace"

    fill_in "Location", with: @workplace.location_id
    fill_in "Name", with: @workplace.name
    fill_in "Status", with: @workplace.status
    click_on "Create Workplace"

    assert_text "Workplace was successfully created"
    click_on "Back"
  end

  test "updating a Workplace" do
    visit workplaces_url
    click_on "Edit", match: :first

    fill_in "Location", with: @workplace.location_id
    fill_in "Name", with: @workplace.name
    fill_in "Status", with: @workplace.status
    click_on "Update Workplace"

    assert_text "Workplace was successfully updated"
    click_on "Back"
  end

  test "destroying a Workplace" do
    visit workplaces_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Workplace was successfully destroyed"
  end
end
