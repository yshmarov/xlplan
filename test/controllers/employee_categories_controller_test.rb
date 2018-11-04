require 'test_helper'

class EmployeeCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee_category = employee_categories(:one)
  end

  test "should get index" do
    get employee_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_employee_category_url
    assert_response :success
  end

  test "should create employee_category" do
    assert_difference('EmployeeCategory.count') do
      post employee_categories_url, params: { employee_category: { category_id: @employee_category.category_id, employee_id: @employee_category.employee_id } }
    end

    assert_redirected_to employee_category_url(EmployeeCategory.last)
  end

  test "should show employee_category" do
    get employee_category_url(@employee_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_employee_category_url(@employee_category)
    assert_response :success
  end

  test "should update employee_category" do
    patch employee_category_url(@employee_category), params: { employee_category: { category_id: @employee_category.category_id, employee_id: @employee_category.employee_id } }
    assert_redirected_to employee_category_url(@employee_category)
  end

  test "should destroy employee_category" do
    assert_difference('EmployeeCategory.count', -1) do
      delete employee_category_url(@employee_category)
    end

    assert_redirected_to employee_categories_url
  end
end
