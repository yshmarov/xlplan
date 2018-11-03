require "application_system_test_case"

class MachinesTest < ApplicationSystemTestCase
  setup do
    @machine = machines(:one)
  end

  test "visiting the index" do
    visit machines_url
    assert_selector "h1", text: "Machines"
  end

  test "creating a Machine" do
    visit machines_url
    click_on "New Machine"

    fill_in "Location", with: @machine.location_id
    fill_in "Name", with: @machine.name
    fill_in "Status", with: @machine.status
    click_on "Create Machine"

    assert_text "Machine was successfully created"
    click_on "Back"
  end

  test "updating a Machine" do
    visit machines_url
    click_on "Edit", match: :first

    fill_in "Location", with: @machine.location_id
    fill_in "Name", with: @machine.name
    fill_in "Status", with: @machine.status
    click_on "Update Machine"

    assert_text "Machine was successfully updated"
    click_on "Back"
  end

  test "destroying a Machine" do
    visit machines_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Machine was successfully destroyed"
  end
end
