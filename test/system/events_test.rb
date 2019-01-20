require "application_system_test_case"

class EventsTest < ApplicationSystemTestCase
  setup do
    @event = events(:one)
  end

  test "visiting the index" do
    visit events_url
    assert_selector "h1", text: "Events"
  end

  test "creating a Event" do
    visit events_url
    click_on "New Event"

    fill_in "Client", with: @event.client_id
    fill_in "Description", with: @event.description
    fill_in "Ends at", with: @event.ends_at
    fill_in "Location", with: @event.location_id
    fill_in "Member", with: @event.member_id
    fill_in "Starts at", with: @event.starts_at
    fill_in "Status", with: @event.status
    fill_in "Status color", with: @event.status_color
    fill_in "Tenant", with: @event.tenant_id
    click_on "Create Event"

    assert_text "Event was successfully created"
    click_on "Back"
  end

  test "updating a Event" do
    visit events_url
    click_on "Edit", match: :first

    fill_in "Client", with: @event.client_id
    fill_in "Description", with: @event.description
    fill_in "Ends at", with: @event.ends_at
    fill_in "Location", with: @event.location_id
    fill_in "Member", with: @event.member_id
    fill_in "Starts at", with: @event.starts_at
    fill_in "Status", with: @event.status
    fill_in "Status color", with: @event.status_color
    fill_in "Tenant", with: @event.tenant_id
    click_on "Update Event"

    assert_text "Event was successfully updated"
    click_on "Back"
  end

  test "destroying a Event" do
    visit events_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Event was successfully destroyed"
  end
end
