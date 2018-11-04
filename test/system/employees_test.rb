require "application_system_test_case"

class EmployeesTest < ApplicationSystemTestCase
  setup do
    @employee = employees(:one)
  end

  test "visiting the index" do
    visit employees_url
    assert_selector "h1", text: "Employees"
  end

  test "creating a Employee" do
    visit employees_url
    click_on "New Employee"

    fill_in "Employment Date", with: @employee.employment_date
    fill_in "Location", with: @employee.location_id
    fill_in "Person", with: @employee.person_id
    fill_in "Specialization", with: @employee.specialization
    fill_in "Status", with: @employee.status
    fill_in "Termination Date", with: @employee.termination_date
    click_on "Create Employee"

    assert_text "Employee was successfully created"
    click_on "Back"
  end

  test "updating a Employee" do
    visit employees_url
    click_on "Edit", match: :first

    fill_in "Employment Date", with: @employee.employment_date
    fill_in "Location", with: @employee.location_id
    fill_in "Person", with: @employee.person_id
    fill_in "Specialization", with: @employee.specialization
    fill_in "Status", with: @employee.status
    fill_in "Termination Date", with: @employee.termination_date
    click_on "Update Employee"

    assert_text "Employee was successfully updated"
    click_on "Back"
  end

  test "destroying a Employee" do
    visit employees_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Employee was successfully destroyed"
  end
end
