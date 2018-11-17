require "application_system_test_case"

class EmployeeServiceCategoriesTest < ApplicationSystemTestCase
  setup do
    @employee_service_category = employee_service_categories(:one)
  end

  test "visiting the index" do
    visit employee_service_categories_url
    assert_selector "h1", text: "Employee Service Categories"
  end

  test "creating a Employee service category" do
    visit employee_service_categories_url
    click_on "New Employee Service Category"

    fill_in "Employee", with: @employee_service_category.employee_id
    fill_in "Service Category", with: @employee_service_category.service_category_id
    click_on "Create Employee service category"

    assert_text "Employee service category was successfully created"
    click_on "Back"
  end

  test "updating a Employee service category" do
    visit employee_service_categories_url
    click_on "Edit", match: :first

    fill_in "Employee", with: @employee_service_category.employee_id
    fill_in "Service Category", with: @employee_service_category.service_category_id
    click_on "Update Employee service category"

    assert_text "Employee service category was successfully updated"
    click_on "Back"
  end

  test "destroying a Employee service category" do
    visit employee_service_categories_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Employee service category was successfully destroyed"
  end
end
