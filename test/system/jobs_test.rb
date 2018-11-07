require "application_system_test_case"

class JobsTest < ApplicationSystemTestCase
  setup do
    @job = jobs(:one)
  end

  test "visiting the index" do
    visit jobs_url
    assert_selector "h1", text: "Jobs"
  end

  test "creating a Job" do
    visit jobs_url
    click_on "New Job"

    fill_in "Client", with: @job.client_id
    fill_in "Client Price", with: @job.client_price
    fill_in "Employee", with: @job.employee_id
    fill_in "Employee Price", with: @job.employee_price
    fill_in "Ends At", with: @job.ends_at
    fill_in "Location", with: @job.location_id
    fill_in "Service Description", with: @job.service_description
    fill_in "Service Duration", with: @job.service_duration
    fill_in "Service", with: @job.service_id
    fill_in "Service Name", with: @job.service_name
    fill_in "Starts At", with: @job.starts_at
    fill_in "Status", with: @job.status
    click_on "Create Job"

    assert_text "Job was successfully created"
    click_on "Back"
  end

  test "updating a Job" do
    visit jobs_url
    click_on "Edit", match: :first

    fill_in "Client", with: @job.client_id
    fill_in "Client Price", with: @job.client_price
    fill_in "Employee", with: @job.employee_id
    fill_in "Employee Price", with: @job.employee_price
    fill_in "Ends At", with: @job.ends_at
    fill_in "Location", with: @job.location_id
    fill_in "Service Description", with: @job.service_description
    fill_in "Service Duration", with: @job.service_duration
    fill_in "Service", with: @job.service_id
    fill_in "Service Name", with: @job.service_name
    fill_in "Starts At", with: @job.starts_at
    fill_in "Status", with: @job.status
    click_on "Update Job"

    assert_text "Job was successfully updated"
    click_on "Back"
  end

  test "destroying a Job" do
    visit jobs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Job was successfully destroyed"
  end
end
