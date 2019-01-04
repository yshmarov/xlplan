require "application_system_test_case"

class AppointmentsTest < ApplicationSystemTestCase
  setup do
    @appointment = appointments(:one)
  end

  test "visiting the index" do
    visit appointments_url
    assert_selector "h1", text: "Appointments"
  end

  test "creating a Appointment" do
    visit appointments_url
    click_on "New Appointment"

    fill_in "Client", with: @appointment.client_id
    fill_in "Description", with: @appointment.description
    fill_in "Ends at", with: @appointment.ends_at
    fill_in "Location", with: @appointment.location_id
    fill_in "Member", with: @appointment.member_id
    fill_in "Starts at", with: @appointment.starts_at
    fill_in "Status", with: @appointment.status
    fill_in "Status color", with: @appointment.status_color
    fill_in "Tenant", with: @appointment.tenant_id
    click_on "Create Appointment"

    assert_text "Appointment was successfully created"
    click_on "Back"
  end

  test "updating a Appointment" do
    visit appointments_url
    click_on "Edit", match: :first

    fill_in "Client", with: @appointment.client_id
    fill_in "Description", with: @appointment.description
    fill_in "Ends at", with: @appointment.ends_at
    fill_in "Location", with: @appointment.location_id
    fill_in "Member", with: @appointment.member_id
    fill_in "Starts at", with: @appointment.starts_at
    fill_in "Status", with: @appointment.status
    fill_in "Status color", with: @appointment.status_color
    fill_in "Tenant", with: @appointment.tenant_id
    click_on "Update Appointment"

    assert_text "Appointment was successfully updated"
    click_on "Back"
  end

  test "destroying a Appointment" do
    visit appointments_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Appointment was successfully destroyed"
  end
end
