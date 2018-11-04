require "application_system_test_case"

class EmployeeCategoriesTest < ApplicationSystemTestCase
  setup do
    @employee_category = employee_categories(:one)
  end

  test "visiting the index" do
    visit employee_categories_url
    assert_selector "h1", text: "Employee Categories"
  end

  test "creating a Employee category" do
    visit employee_categories_url
    click_on "New Employee Category"

    fill_in "Category", with: @employee_category.category_id
    fill_in "Employee", with: @employee_category.employee_id
    click_on "Create Employee category"

    assert_text "Employee category was successfully created"
    click_on "Back"
  end

  test "updating a Employee category" do
    visit employee_categories_url
    click_on "Edit", match: :first

    fill_in "Category", with: @employee_category.category_id
    fill_in "Employee", with: @employee_category.employee_id
    click_on "Update Employee category"

    assert_text "Employee category was successfully updated"
    click_on "Back"
  end

  test "destroying a Employee category" do
    visit employee_categories_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Employee category was successfully destroyed"
  end
end
