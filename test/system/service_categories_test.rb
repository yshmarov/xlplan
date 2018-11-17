require "application_system_test_case"

class ServiceCategoriesTest < ApplicationSystemTestCase
  setup do
    @service_category = service_categories(:one)
  end

  test "visiting the index" do
    visit service_categories_url
    assert_selector "h1", text: "Service Categories"
  end

  test "creating a Service category" do
    visit service_categories_url
    click_on "New Service Category"

    fill_in "Name", with: @service_category.name
    click_on "Create Service category"

    assert_text "Service category was successfully created"
    click_on "Back"
  end

  test "updating a Service category" do
    visit service_categories_url
    click_on "Edit", match: :first

    fill_in "Name", with: @service_category.name
    click_on "Update Service category"

    assert_text "Service category was successfully updated"
    click_on "Back"
  end

  test "destroying a Service category" do
    visit service_categories_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Service category was successfully destroyed"
  end
end
