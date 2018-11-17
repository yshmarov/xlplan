require 'test_helper'

class EmployeeServiceCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee_service_category = employee_service_categories(:one)
  end

  test "should get index" do
    get employee_service_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_employee_service_category_url
    assert_response :success
  end

  test "should create employee_service_category" do
    assert_difference('EmployeeServiceCategory.count') do
      post employee_service_categories_url, params: { employee_service_category: { employee_id: @employee_service_category.employee_id, service_category_id: @employee_service_category.service_category_id } }
    end

    assert_redirected_to employee_service_category_url(EmployeeServiceCategory.last)
  end

  test "should show employee_service_category" do
    get employee_service_category_url(@employee_service_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_employee_service_category_url(@employee_service_category)
    assert_response :success
  end

  test "should update employee_service_category" do
    patch employee_service_category_url(@employee_service_category), params: { employee_service_category: { employee_id: @employee_service_category.employee_id, service_category_id: @employee_service_category.service_category_id } }
    assert_redirected_to employee_service_category_url(@employee_service_category)
  end

  test "should destroy employee_service_category" do
    assert_difference('EmployeeServiceCategory.count', -1) do
      delete employee_service_category_url(@employee_service_category)
    end

    assert_redirected_to employee_service_categories_url
  end
end
