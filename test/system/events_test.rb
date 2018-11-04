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
    fill_in "Client Price", with: @event.client_price
    fill_in "Employee", with: @event.employee_id
    fill_in "Employee Price", with: @event.employee_price
    fill_in "Location", with: @event.location_id
    fill_in "Service Description", with: @event.service_description
    fill_in "Service Duration", with: @event.service_duration
    fill_in "Service", with: @event.service_id
    fill_in "Service Name", with: @event.service_name
    fill_in "Start", with: @event.start
    fill_in "Status", with: @event.status
    click_on "Create Event"

    assert_text "Event was successfully created"
    click_on "Back"
  end

  test "updating a Event" do
    visit events_url
    click_on "Edit", match: :first

    fill_in "Client", with: @event.client_id
    fill_in "Client Price", with: @event.client_price
    fill_in "Employee", with: @event.employee_id
    fill_in "Employee Price", with: @event.employee_price
    fill_in "Location", with: @event.location_id
    fill_in "Service Description", with: @event.service_description
    fill_in "Service Duration", with: @event.service_duration
    fill_in "Service", with: @event.service_id
    fill_in "Service Name", with: @event.service_name
    fill_in "Start", with: @event.start
    fill_in "Status", with: @event.status
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
