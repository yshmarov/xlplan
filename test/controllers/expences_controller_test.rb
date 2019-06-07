require 'test_helper'

class ExpencesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @expence = expences(:one)
  end

  test "should get index" do
    get expences_url
    assert_response :success
  end

  test "should get new" do
    get new_expence_url
    assert_response :success
  end

  test "should create expence" do
    assert_difference('Expence.count') do
      post expences_url, params: { expence: { amount: @expence.amount, expendable_id: @expence.expendable_id, expendable_type: @expence.expendable_type, payment_method: @expence.payment_method, slug: @expence.slug, tenant_id: @expence.tenant_id } }
    end

    assert_redirected_to expence_url(Expence.last)
  end

  test "should show expence" do
    get expence_url(@expence)
    assert_response :success
  end

  test "should get edit" do
    get edit_expence_url(@expence)
    assert_response :success
  end

  test "should update expence" do
    patch expence_url(@expence), params: { expence: { amount: @expence.amount, expendable_id: @expence.expendable_id, expendable_type: @expence.expendable_type, payment_method: @expence.payment_method, slug: @expence.slug, tenant_id: @expence.tenant_id } }
    assert_redirected_to expence_url(@expence)
  end

  test "should destroy expence" do
    assert_difference('Expence.count', -1) do
      delete expence_url(@expence)
    end

    assert_redirected_to expences_url
  end
end
